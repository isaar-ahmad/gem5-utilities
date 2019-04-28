# shell version of llvm-compile.py
# File path are w.r.t gem5-aladdin docker image's directory structure

source=triad
obj=${source}.llvm
source_file=${source}.c

# generate labelmap
${TRACER_HOME}/bin/get-labeled-stmts triad.c -- -I${LLVM_HOME}/lib/clang/3.4
# ${TRACER_HOME}/bin/get-labeled-stmts ${source_file} -- -I${LLVM_HOME}/lib/clang/3.4

#generate triad.llvm
clang -static -g -O1 -S -fno-slp-vectorize -fno-vectorize -fno-unroll-loops -fno-inline -fno-builtin -emit-llvm -o triad.llvm triad.c
# clang -static -g -O1 -S -fno-slp-vectorize -fno-vectorize -fno-unroll-loops -fno-inline -fno-builtin -emit-llvm -o ${source}.llvm ${source_file}

export WORKLOAD=${source}
# generates triad-opt.llvm
opt -disable-inlining -S -load=${TRACER_HOME}/lib/full_trace.so -fulltrace -labelmapwriter triad.llvm -o triad-opt.llvm
# opt -disable-inlining -S -load=${TRACER_HOME}/lib/full_trace.so -fulltrace -labelmapwriter ${source}.llvm -o ${source}-opt.llvm

# generates full.llvm
llvm-link -o full.llvm triad-opt.llvm ${TRACER_HOME}/lib/trace_logger.llvm
# llvm-link -o full.llvm ${source}-opt.llvm ${TRACER_HOME}/lib/trace_logger.llvm

# generates full.s
llc -O0 -disable-fp-elim -filetype=asm -o full.s full.llvm
# llc -O0 -disable-fp-elim -filetype=asm -o full.s full.llvm


#generates triad-instrumented
gcc -static -O0 -fno-inline -o triad-instrumented full.s -lm -lz
# gcc -static -O0 -fno-inline -o ${source}-instrumented full.s -lm -lz
