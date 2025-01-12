# Advent of Code 2019 - Rust 2024

Rust rustc 1.85.0-nightly (2024 edition pre-release), Cargo

## How to run
```sh
cargo run
cargo test
cargo bench
CARGO_PROFILE_BENCH_DEBUG=true cargo flamegraph --root --bench all_days -- --
bench 02 # Run the benchmark for day 02 and output a flamegraph
```

## Execution times

| Day     | Runtime      |     |
| :-----: | :----------: | :-: |
| day01   |     1.39 µs  |  ✅  |
| day02   |     1.66 ms  |     |
| day03   |     4.18 ms  |     |
| day04   |     9.32 µs  |  ✅  |
| day05   |     9.34 µs  |  ✅  |
| day06   |   704.32 µs  |  ✅  |
| day07   |   408.92 µs  |  ✅  |
| day08   |    29.45 µs  |  ✅  |
| day09   |     2.14 ms  |     |
| day10   |     1.09 ms  |     |
| day11   |   787.79 µs  |  ✅  |
| day12   |     5.46 ms  |     |
| day13   |     3.85 ms  |     |
| day14   |   557.84 µs  |  ✅  |
| day15   |   865.86 µs  |  ✅  |
| day16   |    71.86 ms  |     |
| day17   |     1.09 ms  |     |
| day18   |    30.75 ms  |     |
| day19   |    11.16 ms  |     | 
| day20   |    25.29 ms  |     |
| day21   |     3.52 ms  |     |
| day22   |   765.18 µs  |  ✅  |
| day23   |     1.89 ms  |     |
| day24   |     3.54 ms  |     |
| day25   |      N/A     |     |
| Total   |   182.62 ms  |     |
| Average |     7.61 ms  |     |
