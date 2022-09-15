cmake_minimum_required(VERSION 3.18) #FetchContent

if ( NOT CMAKE_TOOLCHAIN_FILE )
    message( FATAL_ERROR "FetchContent/arm-cmsis_5 is intended for cross-compiling Toolchain")
endif()

# Only supported for target cross-compiled build
if ( NOT CMAKE_CROSSCOMPILING )
    return()
endif()

list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/CMake")
include(CPM)

# --------
# Options
# --------
set(   CMSIS_Version    "5.9.0" CACHE STRING "ARM CMSIS library version")
option(CMSIS_FromGitSource "arm::cmsis_5 fetch from source repository" FALSE )

set_property(CACHE CMSIS_Version PROPERTY STRINGS 
    5.9.0
    5.7.0
    5.4.0 
)

# --------
# Validate Options
# --------
# Per version meta data i.e. HASH values
set( CMSIS_5.9.0_Hash 14B366F2821EE5D32F0D3BF48EF9657CA45347261D0531263580848E9D36F8F4 )
set( CMSIS_5.7.0_Hash DFBEF8FE3EDA38298B3F84B13F403AF66437DE9522B41A65E4E99AEE34ED163A )
set( CMSIS_5.4.0_Hash 3356E69292B15A13E30CC5667F640FBD1A5218318C41CC75E2A90F7131295BA5 )

if ( NOT DEFINED CMSIS_${CMSIS_Version}_Hash )
    message( FATAL_ERROR "[Developer Bug] arm::cmsis_5 version Hash missing for 'CMSIS_${CMSIS_Version}_Hash'")
endif()

if ( ${CMSIS_FromGitSource} )
    CPMAddPackage(
        NAME arm-cmsis_5
        GITHUB_REPOSITORY ARM-software/CMSIS_5
        GIT_TAG ${CMSIS_Version}
        DOWNLOAD_ONLY TRUE 
    )
else()
    # https://github.com/ARM-software/CMSIS_5/releases/download/5.4.0/ARM.CMSIS.5.4.0.pack"
    CPMAddPackage(
        NAME arm-cmsis_5
        URL "https://github.com/ARM-software/CMSIS_5/releases/download/${CMSIS_Version}/ARM.CMSIS.${CMSIS_Version}.pack"
        URL_HASH SHA256=${CMSIS_${CMSIS_Version}_Hash}
        VERSION ${CMSIS_Version}
        DOWNLOAD_ONLY YES
    )
endif()

if(arm-cmsis_5_ADDED)

    if ( NOT EXISTS ${arm-cmsis_5_SOURCE_DIR}/CMakeLists.txt )# Inject and use samd51-csp.cmake 
        write_file( ${arm-cmsis_5_SOURCE_DIR}/CMakeLists.txt "include(${CMAKE_CURRENT_LIST_DIR}/arm-cmsis_5.cmake)" )
        if ( ${CMSIS_FromGitSource} ) # Exclude from GIT change detection        
            file(STRINGS ${arm-cmsis_5_SOURCE_DIR}/.git/info/exclude excludes)
            if (NOT "/CMakeLists.txt" IN_LIST excludes) # Add git local exclusion for the generated file
                file( APPEND ${arm-cmsis_5_SOURCE_DIR}/.git/info/exclude "/CMakeLists.txt\n")
            endif()
        endif()
    endif()

    add_subdirectory(${arm-cmsis_5_SOURCE_DIR} ${arm-cmsis_5_BINARY_DIR})
endif()
