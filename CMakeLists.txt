cmake_minimum_required(VERSION 3.12)
project(c-asm-learn
    LANGUAGES C ASM_NASM
)

set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)

option(RELEASE "Build with optimizations" OFF)

file(GLOB ASM_SOURCES lib/examples/*.asm)
file(GLOB C_SOURCES src/*.c)

if(MSVC)
    if(RELEASE)
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /O2 /W4")
    else()
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} /Od /W4")
    endif()
else()
    if(RELEASE)
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -O2 -march=native -Wall -Wextra")
    else()
        set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -g -O0 -Wall -Wextra")
    endif()
endif()

if(WIN32)
    set(CMAKE_ASM_NASM_OBJECT_FORMAT win64)
    set(CMAKE_ASM_NASM_FLAGS "${CMAKE_ASM_NASM_FLAGS} -DWIN64")
    message(STATUS "Target: Windows x64")
else()
    set(CMAKE_ASM_NASM_OBJECT_FORMAT elf64)
    message(STATUS "Target: Linux x86-64")
endif()

set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}")

add_executable(c-asm-learn ${C_SOURCES} ${ASM_SOURCES})
target_include_directories(c-asm-learn PRIVATE ${CMAKE_SOURCE_DIR})
