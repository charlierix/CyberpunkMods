cmake_minimum_required(VERSION 3.15)
project(OrbHackingBridge)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Allow override from command line: -DRED4EXT_SDK_PATH="C:/path/to/sdk/include"
if(NOT RED4EXT_SDK_PATH)
    # set(RED4EXT_SDK_PATH "${CMAKE_SOURCE_DIR}/../../../../sources/RED4ext/RED4ext/Include")
    set(RED4EXT_SDK_PATH "${CMAKE_SOURCE_DIR}/../../../../sdk/RED4ext.SDK/include")
endif()

include_directories(${RED4EXT_SDK_PATH})

set(SOURCES
    src/Main.cpp
    src/OrbHackingBridge.cpp
)

add_library(OrbHackingBridge SHARED ${SOURCES})

set_target_properties(OrbHackingBridge PROPERTIES
    PREFIX ""
    OUTPUT_NAME "OrbHackingBridge"
)

if(WIN32)
    set_target_properties(OrbHackingBridge PROPERTIES
        SUFFIX ".dll"
    )
endif()
