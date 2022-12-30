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
crystal src/aoc-crystal.cr [-d DAY]

# compiled
crystal build src/aoc-crystal.cr [--release]
./aoc-crystal [-d DAY] [-b] [-h]
# -b runs in benchmark mode. This should only be used when compiled with --release

# run tests
crystal spec # Add -t to measure runtime
```

## Execution times

| Day    | Runtime      |     |
| :----: | :----------: | :-: |
| day01  |  108.80 µs   |  ✅  |
| day02  |   53.52 µs   |  ✅  |
| day03  |  341.41 µs   |  ✅  |
| day04  |  224.61 µs   |  ✅  |
| day05  |  286.72 µs   |  ✅  |
| day06  |  429.70 µs   |  ✅  |
| day07  |  269.41 µs   |  ✅  |
| day08  |  358.44 µs   |  ✅  |
| day09  |  930.68 µs   |  ✅  |
| day10  |   63.14 µs   |  ✅  |
| day11  |    6.15 ms   |     |
| day12  |  699.09 µs   |  ✅  |
| day13  |  548.50 µs   |  ✅  |
| day14  |    3.42 ms   |     |
| day15  |  219.60 µs   |  ✅  |
| day16  |   48.69 ms   |     |
| day17  |    1.69 ms   |     |
| day18  |    2.29 ms   |     |
| day19  |   90.46 ms   |     | 
| day20  |  121.75 ms   |     |
| day21  |    1.13 ms   |     |
| day22  |    2.01 ms   |     |
| day23  |   78.75 ms   |     |
| day24  |  118.15 ms   |     |
| day25  |   30.11 µs   |  ✅  |