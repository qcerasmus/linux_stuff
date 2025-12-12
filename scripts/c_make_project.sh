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

echo "CFLAGS := -std=c23 \
	-O2 \
	-Wall \
	-Wextra \
	-Werror \
	-fdiagnostics-color=always \
	-fsanitize=address,undefined \
	-fno-common \
	-Winit-self \
	-Wfloat-equal \
	-Wundef \
	-Wshadow \
	-Wpointer-arith \
	-Wcast-align \
	-Wstrict-prototypes \
	-Wstrict-overflow=5 \
	-Wwrite-strings \
	-Waggregate-return \
	-Wcast-qual \
	-Wswitch-default \
	-Wno-discarded-qualifiers \
	-Wno-aggregate-return

FILES := \$(shell find . -name \"*.c\")

build:
	\$(CC) \$(CFLAGS) \$(FILES) -o ${project_name}">>Makefile

echo "#include <stdio.h>

int main(int argc, char **argv) {
  if (argc > 1) {
    printf(\"Hello, %s\\n\", argv[1]);
	return 0;
  }
  printf(\"Hello, world!\\n\");
  return 0;
}
" >> ${project_name}.c
