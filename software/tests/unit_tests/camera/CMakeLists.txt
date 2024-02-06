set(NAME camera_tests)

add_executable(${NAME}
  camera_tests.cpp
)

target_link_libraries(${NAME}
  GTest::gmock_main
)

target_include_directories(${NAME} PRIVATE
  ${PROJECT_SOURCE_DIR}/include
)

gtest_discover_tests(${NAME})
