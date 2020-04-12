cmake_minimum_required(VERSION 3.17)
project(mccd)

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
  mccd
  ${CMAKE_CURRENT_SOURCE_DIR}/src/Ft245.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/Camera.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/Thermistor.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/CImgPlot.cpp
  ${CMAKE_CURRENT_SOURCE_DIR}/src/ColorWheel.cpp
  )
target_include_directories(
  mccd
  PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR}/include
  ${X11_INCLUDE_DIR}
  ${JPEG_INCLUDE_DIR}
  ${PNG_INCLUDE_DIR}
  )
target_link_libraries(
  mccd
  ${LIBFTDI_LIBRARIES}
  ${X11_LIBRARIES}
  ${JPEG_LIBRARIES}
  ${PNG_LIBRARIES}
  Threads::Threads
  )

# Executables
add_executable(main main.cpp)
target_link_libraries(main mccd)
