#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Please provide the project name."
  exit 1
fi

project_name=$1
if [ -d "$project_name" ]; then
  echo "The directory exists, please delete it first."
  exit 1
fi
mkdir "${project_name}"
cd "${project_name}"
mkdir "include"

touch CMakeLists.txt

echo "cmake_minimum_required(VERSION 3.20)

project(${project_name})

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
set(TESTING ON)

add_subdirectory(third_party)
include_directories(include)
include_directories(\${spdlog_SOURCE})
if (\${TESTING})
  enable_testing()
  include_directories(\${doctest_SOURCE})
  add_subdirectory(testing)
endif()
add_subdirectory(console)
" >> CMakeLists.txt

mkdir third_party
touch third_party/CMakeLists.txt
echo "include(FetchContent)

message(STATUS \"downloading spdlog\")
FetchContent_Declare(
  spdlog
  GIT_REPOSITORY https://github.com/gabime/spdlog.git
  GIT_TAG v1.15.3
  GIT_SHALLOW true
  SOURCE_SUBDIR paththatdoesnotexist
)
FetchContent_MakeAvailable(spdlog)

add_library(spdlog INTERFACE)
set(spdlog_SOURCE \${spdlog_SOURCE_DIR}/include PARENT_SCOPE)

if(\${TESTING})
  FetchContent_Declare(
    doctest
    GIT_REPOSITORY https://github.com/doctest/doctest.git
    GIT_TAG v2.4.12
    GIT_SHALLOW true
    SOURCE_SUBDIR paththatdoesnotexist
  )
  message(STATUS \"downloading doctest\")
  FetchContent_MakeAvailable(doctest)

  add_library(doctest INTERFACE)
  set(doctest_SOURCE \${doctest_SOURCE_DIR}/doctest PARENT_SCOPE)
endif()
" >> third_party/CMakeLists.txt

mkdir console
touch console/CMakeLists.txt
echo "file(GLOB console_headers *.h)
file(GLOB console_sources *.cpp)

add_executable(console \${console_headers} \${console_sources})
" >> console/CMakeLists.txt

touch console/main.cpp
echo "#include <spdlog/common.h>
#include <spdlog/sinks/stdout_color_sinks.h>
#include <spdlog/spdlog.h>

int main()
{
    spdlog::set_level(spdlog::level::trace);
    spdlog::debug(\"Hello, World!\");
}
" >> console/main.cpp

mkdir testing
touch testing/${project_name}.cpp
echo "#define DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
#include \"doctest.h\"

int factorial(int number) { return number <= 1 ? number : factorial(number - 1) * number; }

TEST_CASE(\"testing the factorial function\") {
    CHECK(factorial(1) == 1);
    CHECK(factorial(2) == 2);
    CHECK(factorial(3) == 6);
    CHECK(factorial(10) == 3628800);
}" >> testing/${project_name}.cpp

echo "add_executable(${project_name}_test ${project_name}.cpp)
add_test(${project_name}_test ${project_name}_test)" >> testing/CMakeLists.txt

cp ~/linux_stuff/configs/.clang-format .
git init --initial-branch=main
touch .gitignore
echo "**build-debug/*" >> .gitignore
echo "**build-release/*" >> .gitignore
echo ".cache/*" >> .gitignore
echo "xbuild/*" >> .gitignore

echo "path='Debug'
if [ \"\$#\" -ge 1 ]; then
  path='Release'
fi
if [ ! -d \"xbuild/\$path\" ]; then
  mkdir -p \"xbuild/\$path\" 
fi
cd \"xbuild/\$path\"
cmake ../.. -DCMAKE_BUILD_TYPE=\$path
cmake --build .
cp compile_commands.json ../..
" >> build.sh
chmod +x build.sh
cp ~/linux_stuff/configs/.vimspector.json .
