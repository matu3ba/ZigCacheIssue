#!/bin/sh

CWD=$(pwd)
fail_cnt=0
succ_cnt=0
trap 'echo "succ_cnt: $succ_cnt, fail_cnt: $fail_cnt"' EXIT HUP QUIT SIGSEGV TERM

# Major "--debug-log" targets are: compilation, module, sema, codegen, and link
# requires debug mode or to set -Dlog=true on compiling Zig

i=1
while [ ${i} -le 10 ]; do
  echo "STEP ${i}"
  ZIGCACHE=$(fd -uu zig-cache) && rm -fr "${ZIGCACHE}" && fd -uu zig-cache
  zig build --debug-log sema -freference-trace test &> "step${i}.log"
  ret_val=$?
  test ${ret_val} -eq 0 && succ_cnt=$((succ_cnt+1))
  test ${ret_val} -ne 0 && fail_cnt=$((fail_cnt+1))

  i=$(( i + 1 ))
done

echo "succ_cnt: $succ_cnt, fail_cnt: $fail_cnt"
echo "cwd: ${CWD}"
#TODO bell
