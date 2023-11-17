cmake_minimum_required(VERSION 3.20)
project(StarterProject)

#
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(BUILD_SHARED_LIBS OFF)

#
if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
   message(FATAL_ERROR "In-source builds prohibited.")
endif()

#
function(find_duckdb)

  if(WIN32)
    set(DUCKDB_INCLUDE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/extern/duckdb" CACHE PATH "Path to DuckDB include directory")
    set(DUCKDB_PATH ${PROJECT_SOURCE_DIR}/extern/duckdb/windows-amd64/ CACHE PATH "Path to DuckDB library")
    #find_library(DUCKDB_LIBRARY
    #  NAMES duckdb 
    #  PATHS 
    #  ${PROJECT_SOURCE_DIR}/extern/duckdb/windows-amd64/
    #  REQUIRED
    #)
  else()
    set(DUCKDB_PATH "/usr/local/lib" CACHE PATH "Path to DuckDB library")
  endif()
  
  # Set the Linux-specific path where DuckDB is located
  # Look for the .so file on Linux
  find_library(DUCKDB_LIBRARY
      NAMES duckdb
      PATHS ${DUCKDB_PATH} 
      NO_DEFAULT_PATH
  )


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

#
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

#
add_subdirectory(src)
add_subdirectory(tests)

