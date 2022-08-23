cmake_minimum_required(VERSION 3.18) #FetchContent

# Only supported for target cross-compiled build
if ( NOT CMAKE_CROSSCOMPILING )
    return()
endif()

include(FetchContent)
set(FETCHCONTENT_QUIET FALSE)

# --------
# Options
# --------
# Note: Atmel/Microchip Studio latest version used is 5.4.0
set(   CMSISVersion    "5.4.0" CACHE STRING "ARM CMSIS library version")
option(CMSISFromSource "arm::cmsis_5 fetch from source repository (TBD: Requires extra build steps + incurs CMake Bug-17770)" FALSE )

set_property(CACHE CMSISVersion PROPERTY STRINGS 
    5.7.0
    5.4.0 
)

# --------
# Validate Options
# --------
# Per version meta data i.e. HASH values
set( Meta_CMSIS_5.7.0_Hash DFBEF8FE3EDA38298B3F84B13F403AF66437DE9522B41A65E4E99AEE34ED163A )
set( Meta_CMSIS_5.4.0_Hash 3356E69292B15A13E30CC5667F640FBD1A5218318C41CC75E2A90F7131295BA5 )

if ( NOT DEFINED Meta_CMSIS_${CMSISVersion}_Hash )
    message( FATAL_ERROR "[Developer Bug] arm::cmsis_5 version Hash missing for 'Meta_CMSIS_${CMSISVersion}_Hash'")
endif()

if ( ${CMSISFromSource} )
    # Cmake-BUG 17770 so GIT_SHALLOW checks out ALL branches so downloads a lots more than expected!: https://gitlab.kitware.com/cmake/cmake/-/issues/17770
    FetchContent_Declare(
        arm-cmsis_5
        GIT_REPOSITORY https://github.com/ARM-software/CMSIS_5
        GIT_TAG ${CMSISVersion}
        GIT_SHALLOW TRUE 
        GIT_PROGRESS TRUE
    )
else()
    # https://github.com/ARM-software/CMSIS_5/releases/download/5.4.0/ARM.CMSIS.5.4.0.pack"
    FetchContent_Declare(
        arm-cmsis_5
        URL "https://github.com/ARM-software/CMSIS_5/releases/download/${CMSISVersion}/ARM.CMSIS.${CMSISVersion}.pack"
        URL_HASH SHA256=${Meta_CMSIS_${CMSISVersion}_Hash}
    )
endif()

FetchContent_GetProperties(arm-cmsis_5)
if(NOT arm-cmsis_5_POPULATED)
    FetchContent_Populate(arm-cmsis_5)

    # Inject and use samd51-csp.cmake 
    write_file( ${arm-cmsis_5_SOURCE_DIR}/CMakeLists.txt "include(${CMAKE_CURRENT_LIST_DIR}/arm-cmsis_5.cmake)" )

    add_subdirectory(${arm-cmsis_5_SOURCE_DIR} ${arm-cmsis_5_BINARY_DIR})
endif()
