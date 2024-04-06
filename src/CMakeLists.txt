# generate protobuf artifacts
function(generate_protobuf_bindings LANGUAGE OUT_PATH PROTO_FILE PROTO_SOURCE_DIR)
  file(RELATIVE_PATH PROTO_RELATIVE_PATH ${PROTO_SOURCE_DIR} ${PROTO_FILE})
  set(OUT_OPTION "--${LANGUAGE}_out=${OUT_PATH}")
  execute_process(
    COMMAND ${PROTOC_EXECUTABLE}
            ${OUT_OPTION}
            --proto_path=${PROTO_SOURCE_DIR}
            ${PROTO_RELATIVE_PATH}
    RESULT_VARIABLE result
    OUTPUT_VARIABLE proc_stdout
    ERROR_VARIABLE proc_stderr
    WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  )

  if(NOT "${result}" STREQUAL "0")
    message(SEND_ERROR "Generation of ${LANGUAGE} bindings for ${PROTO_FILE} failed with error:\n${proc_stderr}")
  else()
    message(STATUS "Successfully generated ${LANGUAGE} bindings for ${PROTO_FILE} at ${OUT_PATH}")
  endif()
endfunction()

foreach(PROTO_FILE IN LISTS PROTO_FILES)
  generate_protobuf_bindings("cpp" ${GENERATED_PROTOBUF_PATH} ${PROTO_FILE} ${PROTO_SOURCE_DIR})
  generate_protobuf_bindings("python" ${GENERATED_PROTOBUF_PATH} ${PROTO_FILE} ${PROTO_SOURCE_DIR})
endforeach()

###
add_library(lib_a STATIC lib_a_src/adder.cpp)

if(WITH_CUDA)
  target_sources(lib_a PRIVATE lib_a_src/kernel.cu)
endif()

target_precompile_headers(lib_a PUBLIC ../include/lib_a_dir/pch.h)

target_include_directories(lib_a PUBLIC
  ../include/lib_a_dir 
  ${DUCKDB_INCLUDE_DIR}
)

target_link_libraries(lib_a PRIVATE NLopt::nlopt ${DUCKDB_LIBRARY})

###
add_library(lib_b STATIC lib_b_src/subtractor.cpp)

target_precompile_headers(lib_b REUSE_FROM lib_a)

target_include_directories(lib_b PRIVATE 
  ../include/lib_b_dir 
  ${DUCKDB_INCLUDE_DIR}
)

target_link_libraries(lib_b PRIVATE NLopt::nlopt ${DUCKDB_LIBRARY})

###
file(GLOB PROTOBUF_SRC_FILES "${GENERATED_PROTOBUF_PATH}/*.cc")
add_executable(console console/main.cpp ${PROTOBUF_SRC_FILES})

target_precompile_headers(console REUSE_FROM lib_a )

target_include_directories(console PRIVATE 
   ${NLOPT_INCLUDE_DIRS} 
   ${DUCKDB_INCLUDE_DIR}
   ${ZeroMQ_INCLUDE_DIRS} 
   ${GENERATED_PROTOBUF_PATH}
)

target_link_libraries(console PRIVATE 
  lib_a lib_b cppzmq-static libzmq-static NLopt::nlopt fmt::fmt ${DUCKDB_LIBRARY} ${Protobuf_LIBRARIES}
)

# postbuild: only need this for windows
if(CMAKE_SYSTEM_NAME STREQUAL Windows)
    set(DUCKDB_DLL_DEBUG_PATH ${PROJECT_SOURCE_DIR}/extern/duckdb/windows-amd64/debug/duckdb.dll)
    set(DUCKDB_DLL_RELEASE_PATH ${PROJECT_SOURCE_DIR}/extern/duckdb/windows-amd64/release/duckdb.dll)

    # something not quite right with DuckDB Windows Debug. will result in runtime crash.
    add_custom_command(TARGET console POST_BUILD
                    COMMAND ${CMAKE_COMMAND} -E copy
                    "$<IF:$<CONFIG:Debug>,${DUCKDB_DLL_DEBUG_PATH},${DUCKDB_DLL_RELEASE_PATH}>"
                    $<TARGET_FILE_DIR:console>)
endif()

