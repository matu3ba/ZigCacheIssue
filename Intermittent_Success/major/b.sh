#!/bin/sh
set -e

CWD=$(pwd)
trap "cd ${CWD}" EXIT HUP INT QUIT SIGSEGV TERM

i=1
while [ ${i} -le 100 ]; do
  echo "STEP ${i}"
  ZIGCACHE=$(fd -uu zig-cache) && rm -fr "${ZIGCACHE}" && fd -uu zig-cache
  zig build test

  i=$(( i + 1 ))
done

echo "No failure after ${i} steps"
echo "cwd: ${CWD}"
