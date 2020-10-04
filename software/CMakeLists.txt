cmake_minimum_required(VERSION 3.10)
project(ccd-kaf-cdip24)

set(CMAKE_CXX_STANDARD 17)

# LibFTDI stuff
find_package(LibFTDI1 NO_MODULE REQUIRED)
include(${LIBFTDI_USE_FILE})

# CImg stuff
find_package(X11 REQUIRED)
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
  )
target_link_libraries(
  ccd_kaf_cdip24
  ${LIBFTDI_LIBRARIES}
  ${X11_LIBRARIES}
  ${JPEG_LIBRARIES}
  ${PNG_LIBRARIES}
  Threads::Threads
  )

# Executables
add_executable(ccd_kaf_cdip24_main main.cpp)
target_link_libraries(ccd_kaf_cdip24_main ccd_kaf_cdip24)


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
