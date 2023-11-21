cmake_minimum_required(VERSION 3.21)

# Where to build the targets
set(CMAKE_BINARY_DIR ${CMAKE_SOURCE_DIR}/build)
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR})
set(LIBRARY_OUTPUT_PATH ${CMAKE_BINARY_DIR}/lib)

# Include the SDK
include("${CMAKE_TOOLCHAIN_FILE}")

# Where to find pbres
string(REGEX REPLACE "[^/]+$" "pbres" PBRES "${CMAKE_C_COMPILER}")

# Add the standard link directories
link_directories("${PB_LINK_DIRECTORIES}")

# Add the standard include directories
include_directories("${PB_INCLUDE_DIRECTORIES}")
include_directories("${FREETYPE_INCLUDE_DIRS}")

# Start you CMakeLists.txt here...
add_executable(demo demo.cpp)
target_link_libraries(demo inkview)
