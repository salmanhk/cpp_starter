cmake_minimum_required(VERSION 3.20)
project(StarterProject LANGUAGES CXX)

# Note: To set the "WITH_CUDA" variable see the CMakeSettings.json file. Will only apply to Windows machines
if(WIN32 AND WITH_CUDA)
    message(STATUS "WITH CUDA: ${WITH_CUDA}")
    enable_language(CUDA OPTIONAL)

    # https://cmake.org/cmake/help/latest/prop_tgt/CUDA_STANDARD.html#prop_tgt:CUDA_STANDARD
    set(CMAKE_CUDA_STANDARD 17)
    set(CMAKE_CUDA_STANDARD_REQUIRED ON)
    find_package(CUDAToolkit REQUIRED)
else()
    message(STATUS "CUDA support is not available.")
endif()

#
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(BUILD_SHARED_LIBS OFF)

#
if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
   message(FATAL_ERROR "In-source builds prohibited.")
endif()

#
include(${CMAKE_SOURCE_DIR}/scripts/SetupPythonEnv.cmake)

#
function(find_duckdb)

  if(WIN32)
    set(DUCKDB_INCLUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/extern/duckdb" CACHE PATH "Path to DuckDB include directory")
    
    set(DUCKDB_PATH_RELEASE ${PROJECT_SOURCE_DIR}/extern/duckdb/windows-amd64/release CACHE PATH "Path to DuckDB Release library")
    set(DUCKDB_PATH_DEBUG ${PROJECT_SOURCE_DIR}/extern/duckdb/windows-amd64/debug CACHE PATH "Path to DuckDB Debug library")

    set(DUCKDB_PATH "$<IF:$<CONFIG:Debug>,${DUCKDB_PATH_DEBUG},${DUCKDB_PATH_RELEASE}>" CACHE PATH "Path to DuckDB library")
  else()
    set(DUCKDB_PATH "/usr/local/lib" CACHE PATH "Path to DuckDB library")
  endif()
  
  find_library(DUCKDB_LIBRARY
      NAMES duckdb
      PATHS ${DUCKDB_PATH} ${DUCKDB_PATH_RELEASE} ${DUCKDB_PATH_DEBUG}
      NO_DEFAULT_PATH
  )

  #
  if(NOT DUCKDB_LIBRARY)
      message(FATAL_ERROR "Could not find DuckDB")
  else()
      message(STATUS "Found DuckDB: ${DUCKDB_LIBRARY}")
  endif()

  set(DUCKDB_LIBRARY ${DUCKDB_LIBRARY} PARENT_SCOPE)
endfunction()


#
add_compile_definitions(
  EIGEN_STACK_ALLOCATION_LIMIT=0
  EIGEN_DONT_PARALLELIZE
  ZMQ_STATIC
  USE_PRECOMPILED_HEADERS=1
  JSON_USE_IMPLICIT_CONVERSIONS=0
)

#
if(WIN32)
  set(VCPKG_TARGET_TRIPLET "x64-windows-static" CACHE STRING "Vcpkg target triplet")
  if(MSVC)
    set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
  endif()
elseif(UNIX AND NOT APPLE)
  set(VCPKG_TARGET_TRIPLET "x64-linux" CACHE STRING "Vcpkg target triplet")
endif()

find_package(cppzmq CONFIG REQUIRED)
find_package(Eigen3 CONFIG REQUIRED)
find_package(fmt CONFIG REQUIRED)
find_package(GTest CONFIG REQUIRED)
find_package(nlohmann_json CONFIG REQUIRED)
find_package(NLopt CONFIG REQUIRED)
find_package(spdlog CONFIG REQUIRED)
find_package(Threads REQUIRED)
find_package(websocketpp CONFIG REQUIRED)
find_package(ZeroMQ CONFIG REQUIRED)
find_duckdb()

# Protobuf
find_package(Protobuf CONFIG REQUIRED)
set(PROTO_SOURCE_DIR ${PROJECT_SOURCE_DIR}/src/proto)
file(GLOB PROTO_FILES "${PROTO_SOURCE_DIR}/*.proto")
set(PROTOC_EXECUTABLE ${Protobuf_PROTOC_EXECUTABLE})
set(GENERATED_PROTOBUF_PATH "${CMAKE_SOURCE_DIR}/build/protobufs")
file(MAKE_DIRECTORY ${GENERATED_PROTOBUF_PATH})

# path to python scripts
set(SCRIPTS_DIR ${CMAKE_SOURCE_DIR}/scripts)
add_compile_definitions(SCRIPTS_DIR="${SCRIPTS_DIR}")

#
add_subdirectory(src)
add_subdirectory(tests)

