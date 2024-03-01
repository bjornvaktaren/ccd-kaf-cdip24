set(NAME camera_configuration_tests)

add_executable(${NAME}
  camera_configuration_tests.cpp
  ${PROJECT_SOURCE_DIR}/src/CameraConfiguration.cpp
)

target_link_libraries(${NAME}
  GTest::gmock_main
)

target_include_directories(${NAME} PRIVATE
  ${PROJECT_SOURCE_DIR}/include
  ${PROJECT_SOURCE_DIR}/tests/unit_tests/
)

gtest_discover_tests(${NAME})
