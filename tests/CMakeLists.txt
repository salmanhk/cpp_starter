#[[ TESTS ]]

include(GoogleTest)
enable_testing()
set(THIS tests)
file(GLOB_RECURSE SRC_FILES ${PROJECT_SOURCE_DIR}/tests/*.cpp)
add_executable(${THIS} ${SRC_FILES})

target_include_directories(${THIS} 
  PRIVATE 
    ${INCLUDE_PATH_EIGEN3}
    ${INCLUDE_PATH_DUCKDB}
    ${PROJECT_SOURCE_DIR}/include/lib_a_dir/
)

target_link_libraries(${THIS} PRIVATE 
    GTest::gmock
    GTest::gtest
    GTest::gmock_main
    GTest::gtest_main
    lib_a
)

gtest_discover_tests(${THIS} DISCOVERY_TIMEOUT 30)
add_test(NAME ${THIS} COMMAND ${THIS})

