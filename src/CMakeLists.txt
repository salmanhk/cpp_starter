###
add_library(lib_a STATIC lib_a_src/adder.cpp lib_a_src/kernel.cu)

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
add_executable(console console/main.cpp)

target_precompile_headers(console REUSE_FROM lib_a)

target_include_directories(console PRIVATE 
  ${NLOPT_INCLUDE_DIRS} 
  ${DUCKDB_INCLUDE_DIR}
  ${ZeroMQ_INCLUDE_DIRS} 
)

target_link_libraries(console PRIVATE 
  lib_a lib_b cppzmq-static libzmq-static NLopt::nlopt fmt::fmt ${DUCKDB_LIBRARY}
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

