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

## Execution times

| Day    | Runtime  |
| :----: | :------: |
| Day 01 | 0 ms     |
| Day 02 | 1 ms     |
| Day 03 | 16 ms    |
| Day 04 | 4239 ms  |
| Day 05 | 7 ms     |
| Day 06 | 212 ms   |
| Day 07 | 46 ms    |
| Day 08 | 1 ms     |
| Day 09 | 8 ms     |
| Day 10 | 284 ms   |
| Day 11 | 203 ms   |
| Day 12 | 288 ms   |
| Day 13 | 96 ms    |
| Day 14 | 1 ms     |
| Day 15 | 9 ms     |
| Day 16 | 6 ms     |
| Day 17 | 19 ms    |
| Day 18 | 72 ms    |
| Day 19 | 11 ms    |
| Day 20 | 37 ms    |
| Day 21 | 1 ms     |
| Day 22 | 97 ms    |
| Day 23 | 1 ms     |
| Day 24 | 71 ms    |
| Day 25 | 0 ms     |
| Total  | 5.72 s   |