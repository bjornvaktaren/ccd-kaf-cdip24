cmake_minimum_required(VERSION 3.10)
project(ccd-kaf-cdip24)

set(CMAKE_CXX_STANDARD 17)

set(CMAKE_EXPORT_COMPILE_COMMANDS On)

# LibFTDI stuff
find_package(LibFTDI1 NO_MODULE REQUIRED)
include(${LIBFTDI_USE_FILE})

# CImg stuff
find_package(X11 REQUIRED)
find_package(TIFF REQUIRED)
find_package(JPEG REQUIRED)
find_package(PNG REQUIRED)
find_package(Threads REQUIRED)

# Library for this project
add_library(
  ccd_kaf_cdip24
  ${CMAKE_CURRENT_SOURCE_DIR}/src/Ft245.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/Camera.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/Thermistor.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/CImgPlot.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/ColorWheel.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/PID.cpp
  )
set_property(
  TARGET ccd_kaf_cdip24
  PROPERTY
  POSITION_INDEPENDENT_CODE ON
  )
target_include_directories(
  ccd_kaf_cdip24
  PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR}/include
  ${X11_INCLUDE_DIR}
  ${JPEG_INCLUDE_DIR}
  ${PNG_INCLUDE_DIR}
  ${TIFF_INCLUDE_DIR}
  )
target_link_libraries(
  ccd_kaf_cdip24
  ${LIBFTDI_LIBRARIES}
  ${X11_LIBRARIES}
  ${JPEG_LIBRARIES}
  ${PNG_LIBRARIES}
  ${TIFF_LIBRARIES}
  Threads::Threads
  )

# Executables
add_executable(ccd_kaf_cdip24_main main.cpp)
target_link_libraries(ccd_kaf_cdip24_main ccd_kaf_cdip24)

# Test executables
add_executable(test_pid ${CMAKE_CURRENT_SOURCE_DIR}/tests/pid.cpp)
target_link_libraries(test_pid ccd_kaf_cdip24)
add_executable(
  test_data_transfer ${CMAKE_CURRENT_SOURCE_DIR}/tests/data_transfer.cpp
)
target_link_libraries(test_data_transfer ccd_kaf_cdip24)
  
add_executable(platform_loopback_test ${CMAKE_CURRENT_SOURCE_DIR}/tests/platform/loopback.cpp)
target_link_libraries(platform_loopback_test ccd_kaf_cdip24)

add_subdirectory(tests/unit_tests)

# Debian package
set(CPACK_GENERATOR DEB)
set(CPACK_PACKAGE_VERSION_MAJOR "0")
set(CPACK_PACKAGE_VERSION_MINOR "0")
set(CPACK_PACKAGE_VERSION_PATCH "1")
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Mikael Mårtensson")
set(CPACK_PACKAGE_CONTACT "mikmar6@gmail.com")
# use dpkg-shlibdeps to find shared library dependencies
set(CPACK_DEBIAN_PACKAGE_SHLIBDEPS ON)

include(CPack)
