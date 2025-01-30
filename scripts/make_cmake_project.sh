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

touch CMakeLists.txt

echo "cmake_minimum_required(VERSION 3.20)

project(${project_name})

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)

add_subdirectory(third_party)
include_directories(\${spdlog_SOURCE})
add_subdirectory(console)
" >> CMakeLists.txt

mkdir third_party
touch third_party/CMakeLists.txt
echo "include(FetchContent)

FetchContent_Declare(
  spdlog
  GIT_REPOSITORY https://github.com/gabime/spdlog.git
  GIT_TAG v1.13.0
  CONFIGURE_COMMAND ""
  BUILD_COMMAND ""
)

FetchContent_GetProperties(spdlog)
if (NOT spdlog_POPULATED)
  FetchContent_Populate(spdlog)
endif()

add_library(spdlog INTERFACE)
set(spdlog_SOURCE \${spdlog_SOURCE_DIR}/include PARENT_SCOPE)
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

cp ~/linux_stuff/configs/.clang-format .
git init --initial-branch=main
touch .gitignore
echo "**build-debug/*" >> .gitignore
echo "**build-release/*" >> .gitignore
echo ".cache/*" >> .gitignore

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
