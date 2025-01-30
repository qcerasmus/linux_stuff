#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Please provide the program name."
  exit 1
fi

valgrind --leak-check=full --show-leak-kinds=all --track-origins=yes $1

