cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

# ---- Project ----

# Note: update this to your new project's name and version
project(
  Greeter
  VERSION 1.0
  LANGUAGES CXX
)

# ---- Include guards ----

if(PROJECT_SOURCE_DIR STREQUAL PROJECT_BINARY_DIR)
  message(
    FATAL_ERROR
      "In-source builds not allowed. Please make a new directory (called a build directory) and run CMake from there."
  )
endif()

# ---- Add dependencies via CPM ----
# see https://github.com/TheLartians/CPM.cmake for more info

include(cmake/CPM.cmake)

# PackageProject.cmake will be used to make our target installable
CPMAddPackage("gh:TheLartians/PackageProject.cmake@1.6.0")

CPMAddPackage(
  NAME fmt
  GIT_TAG 7.1.3
  GITHUB_REPOSITORY fmtlib/fmt
  OPTIONS "FMT_INSTALL YES" # create an installable target
)

# add boost 
#CPMAddPackage("gh:Orphis/boost-cmake#7f97a08b64bd5d2e53e932ddf80c40544cf45edf@1.71.0")

# add json
#CPMAddPackage("gh:nlohmann/json@3.9.1")

# add cxxopts 
# the install option has to be explicitly set to allow installation
#CPMAddPackage(
#  NAME cxxopts
#  GITHUB_REPOSITORY jarro2783/cxxopts
#  VERSION 2.2.1
#  OPTIONS "CXXOPTS_BUILD_EXAMPLES NO" "CXXOPTS_BUILD_TESTS NO" "CXXOPTS_ENABLE_INSTALL YES"
#)

# add google benchmark 
#CPMAddPackage("gh:cpm-cmake/testpack-fibonacci@2.0")

#CPMAddPackage(
#  NAME benchmark
#  GITHUB_REPOSITORY google/benchmark
#  VERSION 1.5.2
#  OPTIONS "BENCHMARK_ENABLE_TESTING Off"
#)

#if(benchmark_ADDED)
#  # enable c++11 to avoid compilation errors
#  set_target_properties(benchmark PROPERTIES CXX_STANDARD 11)
#endif()

# include eigen
# find_package(Threads REQUIRED)

SET(EIGEN3_INCLUDE_DIR "$ENV{EIGEN3_INCLUDE_DIR}" )
IF( NOT EIGEN3_INCLUDE_DIR )
    MESSAGE( FATAL_ERROR "Please point the environment variable EIGEN3_INCLUDE_DIR to the include directory of your Eigen3 installation.")
ENDIF()
INCLUDE_DIRECTORIES ( "${EIGEN3_INCLUDE_DIR}" )

# ---- Add source files ----

# Note: globbing sources is considered bad practice as CMake's generators may not detect new files
# automatically. Keep that in mind when changing files, or explicitly mention them here.
file(GLOB_RECURSE headers CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/include/*.h")
file(GLOB_RECURSE sources CONFIGURE_DEPENDS "${CMAKE_CURRENT_SOURCE_DIR}/source/*.cpp")

# ---- Create library ----

# Note: for header-only libraries change all PUBLIC flags to INTERFACE and create an interface
# target: add_library(Greeter INTERFACE)
add_library(Greeter ${headers} ${sources})

set_target_properties(Greeter PROPERTIES CXX_STANDARD 17)

# being a cross-platform target, we enforce standards conformance on MSVC
target_compile_options(Greeter PUBLIC "$<$<COMPILE_LANG_AND_ID:CXX,MSVC>:/permissive->")

# Link dependencies
target_link_libraries(Greeter PRIVATE fmt::fmt) 
# Boost::system Threads::Threads cxxopts nlohmann_json::nlohmann_json fibonacci benchmark)

target_include_directories(
  Greeter PUBLIC $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
                 $<INSTALL_INTERFACE:include/${PROJECT_NAME}-${PROJECT_VERSION}>
)

# ---- Create an installable target ----
# this allows users to install and find the library via `find_package()`.

# the location where the project's version header will be placed should match the project's regular
# header paths
string(TOLOWER ${PROJECT_NAME}/version.h VERSION_HEADER_LOCATION)

packageProject(
  NAME ${PROJECT_NAME}
  VERSION ${PROJECT_VERSION}
  NAMESPACE ${PROJECT_NAME}
  BINARY_DIR ${PROJECT_BINARY_DIR}
  INCLUDE_DIR ${PROJECT_SOURCE_DIR}/include
  INCLUDE_DESTINATION include/${PROJECT_NAME}-${PROJECT_VERSION}
  VERSION_HEADER "${VERSION_HEADER_LOCATION}"
  COMPATIBILITY SameMajorVersion
  DEPENDENCIES "fmt 7.1.3"
)
