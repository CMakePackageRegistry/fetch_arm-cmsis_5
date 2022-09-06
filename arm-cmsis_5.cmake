# This Cmake will be injected into the root folder of FetchCOntent for https://github.com/ARM-software/CMSIS_5
cmake_minimum_required(VERSION 3.18)

project( arm-cmsis_5 LANGUAGES C ASM)

add_library(arm-cmsis_5 INTERFACE)
#set_target_properties( arm-cmsis_5 PROPERTIES
 #   C_STANDARD 11
#)

target_include_directories( arm-cmsis_5
    INTERFACE
        ${CMAKE_CURRENT_SOURCE_DIR}/CMSIS/Core/Include/
        ${CMAKE_CURRENT_SOURCE_DIR}/CMSIS/CoreValidation/Include/
        ${CMAKE_CURRENT_SOURCE_DIR}/CMSIS/DSP/Include/
        ${CMAKE_CURRENT_SOURCE_DIR}/CMSIS/Driver/Include/
    #PRIVATE
    #     $<$<CXX_COMPILER_ID:GNU>: ${CMAKE_CURRENT_SOURCE_DIR}/CMSIS/Lib/GCC/>
)

#target_sources( arm-cmsis_5 
  #  PRIVATE
       #  $<$<CXX_COMPILER_ID:GNU>: ${CMAKE_CURRENT_SOURCE_DIR}/Device/ARM/ARMCM4/Source/GCC/startup_ARMCM4.S>
        # $<$<CXX_COMPILER_ID:GNU>: ${CMAKE_CURRENT_SOURCE_DIR}/Device/ARM/ARMCM4/Source/GCC/gcc_arm.ld>
#)

# TODO: -L{runtime.tools.CMSIS-5.4.0.path}/CMSIS/Lib/GCC/"  -larm_cortexM4lf_math.a
#target_link_options( arm-cmsis_5  PRIVATE 
#	-L${nRF5_SDK_ROOT}/modules/nrfx/mdk
#	-T${CMAKE_CURRENT_SOURCE_DIR}/gcc_nrf52.ld
#)

target_link_options( arm-cmsis_5  PUBLIC 
	#-L$<$<CXX_COMPILER_ID:GNU>: ${CMAKE_CURRENT_SOURCE_DIR}/Device/ARM/ARMCM4/Source/GCC/>
	#-T$<$<CXX_COMPILER_ID:GNU>: ${CMAKE_CURRENT_SOURCE_DIR}/Device/ARM/ARMCM4/Source/GCC/gcc_arm.ld>
)

# Alias name
add_library( arm::cmsis_5 ALIAS arm-cmsis_5 )

