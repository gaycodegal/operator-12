#!/bin/bash
set -euo pipefail

export LLVM_ROOT='wasm_toolchain/emscripten_clang'
export EMSCRIPTEN_NATIVE_OPTIMIZER='wasm_toolchain/emscripten_clang/optimizer'
export BINARYEN_ROOT='wasm_toolchain/emscripten_clang/'
export NODE_JS=''
export EMSCRIPTEN_ROOT='wasm_toolchain/emscripten_toolchain'
export SPIDERMONKEY_ENGINE=''
export EM_EXCLUSIVE_CACHE_ACCESS=1
export EMCC_SKIP_SANITY_CHECK=1
export EMCC_WASM_BACKEND=0
export EM_CACHE="wasm_toolchain/emscripten_cache"

python wasm_toolchain/emscripten_toolchain/emcc.py "$@"

# delete lines from the dependencies file that use absolute paths

python wasm_toolchain/dependency_cleaner.py "$@"
