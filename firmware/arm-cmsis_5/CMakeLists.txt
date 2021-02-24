cmake_minimum_required (VERSION 3.15) #FetchContent

include(FetchContent)
set(FETCHCONTENT_QUIET FALSE)

# Cmake-BUG 17770 so GIT_SHALLOW checks out ALL banches: https://gitlab.kitware.com/cmake/cmake/-/issues/17770
# GIT_REPOSITORY https://github.com/ARM-software/CMSIS_5  GIT_TAG 5.7.0 GIT_SHALLOW TRUE GIT_PROGRESS TRUE
FetchContent_Declare(
    arm-cmsis_5
    URL https://github.com/ARM-software/CMSIS_5/releases/download/5.7.0/ARM.CMSIS.5.7.0.pack
    URL_HASH SHA256=DFBEF8FE3EDA38298B3F84B13F403AF66437DE9522B41A65E4E99AEE34ED163A
)

FetchContent_GetProperties(arm-cmsis_5)
if(NOT arm-cmsis_5_POPULATED)
    FetchContent_Populate(arm-cmsis_5)

    # Inject and use samd51-csp.cmake 
    write_file( ${arm-cmsis_5_SOURCE_DIR}/CMakeLists.txt "include(${CMAKE_CURRENT_LIST_DIR}/arm-cmsis_5.cmake)" )

    add_subdirectory(${arm-cmsis_5_SOURCE_DIR} ${arm-cmsis_5_BINARY_DIR})
endif()
