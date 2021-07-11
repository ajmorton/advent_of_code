# Advent of Code 2015 - C++20

Solutions to Advent of Code 2015 in C++.  
Uses `bazel` as a build system and `catch2` as a test framework.

## Setup 
bazel 4.1.0 doesn't support Apple Silicon so the local_config_cc/BUILD files need [to be manually updated](https://github.com/bazelbuild/bazel/issues/13514#issuecomment-847917936). This will need to be repeated after every `bazel clean`.  
`cxx+flags` also needs to be updated from `c++0x`.  

`compile_flags.txt` has been configured such that linting works in VSCode using the `clangd` extension.

## Commands
`bazel run` to build and execute  
`bazel test` to run automated tests
