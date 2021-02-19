cmake_minimum_required (VERSION 3.15) #FetchContent


include(FetchContent)

FetchContent_Declare(
  arm-cmsis_5
  GIT_REPOSITORY https://github.com/ARM-software/CMSIS_5
  #GIT_TAG        5.7.0
)

FetchContent_GetProperties(arm-cmsis_5)

if(NOT arm-cmsis_5_POPULATED)
    FetchContent_Populate(arm-cmsis_5)

    # Copy arm-cmsis_5.cmake to arm-cmsis_5/CMakeLists.txt
    file(COPY arm-cmsis_5.cmake DESTINATION ${arm-cmsis_5_SOURCE_DIR})
    file(RENAME ${arm-cmsis_5_SOURCE_DIR}/arm-cmsis_5.cmake ${arm-cmsis_5_SOURCE_DIR}/CMakeLists.txt)

    add_subdirectory(${arm-cmsis_5_SOURCE_DIR} ${arm-cmsis_5_BINARY_DIR})
endif()

# Alias same as findGTest()
add_library( arm::cmsis_5 ALIAS arm-cmsis_5 )