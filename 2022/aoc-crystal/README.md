# Advent of Code 2022 - Crystal

Crystal 1.6.1

## Language server notes
Currently broken - Some segfault with no clear indications as to why.  

The language server `crystalline` doesn't have a brew formula for M1 macs, so you'll need to compile it locally.  
This requires using the LLVM from crystal's dependencies (provided you've installed via `brew`), but brew doesn't automatically link it to avoid issues with multiple LLVM versions on the same machine.  
As such, when compiling `crystalline` you'll need to do specify the path to `llvm-config`: 
`LLVM_CONFIG=/opt/homebrew/opt/llvm@14/bin/llvm-config crystal build src/crystalline.cr`

Once done add the full path to the compiled `crystalline` binary to VSCode.

## How to run
```bash
# interpreted
crystal src/aoc-crystal.cr`

# compiled
crystal build src/aoc-crystal.cr
./aoc-crystal

# run tests
crystal spec # Add -t to measure runtime
```

## Execution times

| Day    | Runtime      |     |
| :----: | :----------: | :-: |
| day01  |              |     |
| day02  |              |     |
| day03  |              |     |
| day04  |              |     |
| day05  |              |     |
| day06  |              |     |
| day07  |              |     |
| day08  |              |     |
| day09  |              |     |
| day10  |              |     |
| day11  |              |     |
| day12  |              |     |
| day13  |              |     |
| day14  |              |     |
| day15  |              |     |
| day16  |              |     |
| day17  |              |     |
| day18  |              |     |
| day19  |              |     | 
| day20  |              |     |
| day21  |              |     |
| day22  |              |     |
| day23  |              |     |
| day24  |              |     |
| day25  |              |     |