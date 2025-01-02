# Thoughts on Rust 2024

## Day 00 - Initial setup
Broken Window Theory is real people. I do a second year of Python and here we are straight back to Rust. Apparently it's been 3 years (and 1 day) since the last sortie. We'll see how much I remember. This also has the added benefit of maybe possibly potentially coming in useful for work related reasons 👀. We shall see.

Bit of a cheat to start with. Just stole the folder structure from 2018 including criterion for benchmarking. As always cargo is nice, but we're already at 61 dependencies so we're certainly off to a dependable (ha) start.

## Day 1: The Tyranny of the Rocket Equation
I forgot how good Rust error messages are. Exact line, exact issue, a link for further info and the proposed solution all in one. B-e-a-utiful. Runtime is already down to 2 µs which bodes well Including the input in the binary removes the entire I/O cost though, so arguable not generic across all inputs. I think I'll chase a total time of < 50ms for this year.
