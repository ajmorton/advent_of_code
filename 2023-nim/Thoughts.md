# Thoughts on Nim as things progress

## Day 00 - Setting up the framework

Bot of a rough start here. 

#### stdlibs
Perhaps I'm expecting a python level stdlib, but command line parsing is far from obvious:
- `cmdline` isn't supported on Posix
- `parseopt` seems better (note the functions are called parseopt but the lib is optparse). However it still doesn't explain how to fetch text from the command line and all examples just use hardcoded strings. Help text, parsed args, and handling of each each arg is decoupled so any new arg requires changes in 3 locations.
- `cligen` seems genuinely nice, just add a new argument to a function and good to go! 

#### Docs
Docs are robust but the search bar creates a new entry at the top of the page and if I'm not at the top of the page it's invisible. This happens on FFox and Safari so I don't think it's me. Took me a while to realise what was happening and that search wasn't broken.

#### Nimble
Disclaimer: nimble is pre-release (`0.14.2`). These are gripes about a product in alpha.

Annoyingly `nimble run` seems to eat the `--help` flag. It works when I `nimble build` and call `aoc_2023_nim --help`, but `nimble run aoc_2023_nim --help` sees nothing. I found [this PR](https://github.com/nim-lang/nimble/issues/725) that notes nimble is stealing the `--help` flag and considering it as an arg for nimble instead of the compiled binary, but rather than pass the flag through to the app the solution seems to just suppress nimble from printing out help text(??). For now just falling back on `nimble build; ./aoc_2023_nim --help` rather than fight it.

Apart from the above nimble seems lightweight and solid. Need a new dependency? Stick `requires "new_dependency >= 1.0.0"` and boom you're off to the races. `nimble search` could use some refining as my search for `command-line` pumped out too many results to begin parsing and they don't seem to be ordered by popularity, but overall things seem clean. `nimble init` also has a good set of prompts to get a repo up and running including a default licence file which I don't remember seeing elsewhere.

#### The actual code
Clean, easy, straight forward. Reading in a file and converting the contents to a list of ints is just two lines
```
let input = readFile(input_file).strip(leading = false)
return input.splitLines.map(parseInt)
```

I've started with 2019 day01 since 2023 doesn't release until tomorrow. Adding imports is easy. Testing is just `check foo == bar`. The code is short and concise.  
I'm taking a while to find stdlib functions like sum and fold, but that's on me and my lack of language familiarity. One annoying things is I've needed to include `math` to get the `sum` function to fold an array of ints, and once it's included nimble annoys the C linker which complains that the math lib is included twice `ld: warning: ignoring duplicate libraries: '-lm'`. 


## Day 01 - Trebuchet?!

Mostly smooth sailing. A couple of issues finding stdlib functions but I'm just spoiled by IDEs with better autocomplete and linting.  Using anonymous functions requires importing the sugar library which implies it's not part of the language grammar? Must be some macro magic going on. The callstack and error messages feel a bit barebones compared to previous AoC languages. I'm also having issues reasoning about perf. I had the (simplified) code 
```nim
    while str.len() > 0:
        if str.startsWith(foo)
            # Do something
    str = str[1..^1]
```
which modifies and re-assigns the string on each iteration and thought I could get rid of the string assignments with
```nim
    var i = 0
    while i < str.len():
        if str[i..^1].startsWith(foo)
            # Do something
    i += 1
```
but this comes out slower(?). I suspect string slicing creates a brand new string instead of doing some pointer arith like I wanted. Perf results are a bit bouncy bouncy, roughly halving after the first run and then ~10% deviance on each subsequent run. Will need to clean that up at some point. Runtime is sitting around 1.9 ms. Would like to get that under 1 at some point.
