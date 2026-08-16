cmake_minimum_required(VERSION 3.15)
project(HoverRotTesterPlayer9_1a VERSION 1.0.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# RED4ext SDK path - adjust to your local setup
if(NOT RED4EXT_SDK_PATH)
    set(RED4EXT_SDK_PATH "${CMAKE_CURRENT_SOURCE_DIR}/../../../sdk/RED4ext.SDK/include"
        CACHE PATH "Path to RED4ext SDK include directory")
endif()

# Output directory - the built DLL goes into red4ext/bin/
set(OUTPUT_DIR "${CMAKE_CURRENT_SOURCE_DIR}/bin"
    CACHE PATH "Output directory for the built plugin")

add_library(HoverRotTesterPlayer9_1a SHARED
    src/Main.cpp
)

target_include_directories(HoverRotTesterPlayer9_1a PRIVATE
    ${RED4EXT_SDK_PATH}
)

set_target_properties(HoverRotTesterPlayer9_1a PROPERTIES
    OUTPUT_NAME "HoverRotTesterPlayer9_1a"
    RUNTIME_OUTPUT_DIRECTORY ${OUTPUT_DIR}
    LIBRARY_OUTPUT_DIRECTORY ${OUTPUT_DIR}
)

# Visual Studio multi-config generators append the config name (Release/Debug)
# as a subfolder. Override per-config output dirs to put the DLL directly
# in the target folder.
foreach(CFG ${CMAKE_CONFIGURATION_TYPES})
    string(TOUPPER ${CFG} CFG_UPPER)
    set_target_properties(HoverRotTesterPlayer9_1a PROPERTIES
        RUNTIME_OUTPUT_DIRECTORY_${CFG_UPPER} ${OUTPUT_DIR}
        LIBRARY_OUTPUT_DIRECTORY_${CFG_UPPER} ${OUTPUT_DIR}
    )
endforeach()

# Link against RED4ext SDK (if it has a library to link)
if(EXISTS "${RED4EXT_SDK_PATH}/lib/RED4ext.lib")
    target_link_libraries(HoverRotTesterPlayer9_1a PRIVATE
        ${RED4EXT_SDK_PATH}/lib/RED4ext.lib
    )
endif()

# Windows-specific settings (RED4ext plugins are Windows DLLs)
if(WIN32)
    set_target_properties(HoverRotTesterPlayer9_1a PROPERTIES
        SUFFIX ".dll"
        PREFIX ""
    )
endif()
