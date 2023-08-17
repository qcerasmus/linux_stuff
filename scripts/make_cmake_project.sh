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
add_subdirectory(console)
" >> CMakeLists.txt

mkdir third_party
touch third_party/CMakeLists.txt
echo "include(FetchContent)
" >> third_party/CMakeLists.txt

mkdir console
touch console/CMakeLists.txt
echo "file(GLOB console_headers *.h)
file(GLOB console_sources *.cpp)

add_executable(console \${console_headers} \${console_sources})
" >> console/CMakeLists.txt

touch console/main.cpp
echo "#include <iostream>

int main()
{
    std::cout << \"Hello World\\n\";
}
" >> console/main.cpp

cp ~/configs/.clang-format .
git init --initial-branch=main
touch .gitignore
echo "**build-debug/*" >> .gitignore
echo "**build-release/*" >> .gitignore
mkdir build-debug
mkdir build-release
logicalCpuCount=$([ $(uname) = 'Darwin' ] &&
                       sysctl -n hw.logicalcpu_max ||
                       lscpu -p | egrep -v '^#' | wc -l)
cd build-debug
cmake .. -DCMAKE_BUILD_TYPE=Debug
cmake --build . -j$((logicalCpuCount-4))
cd ../build-release
cmake ..
cmake --build . -j$((logicalCpuCount-4))
