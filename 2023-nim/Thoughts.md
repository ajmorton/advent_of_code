# Thoughts on Nim as things progress

## Final thoughts
Solid language 👍. Flexible, good stdlib, easy to read and write. 
Most of my issues came from the language server being a bit weak, for example in the line`let foo = connsCopy[egeA].find(edgeB)` reports an error on the entire line saying `expression '' has no type (or is ambiguous)`, although the correct `undeclared identifier: 'edgA'` error is there if you look for it.  

Runtimes for this year are good with less than 200 ms at the time of writing and 15 out of 25 days running in under a millisecond. I'll try shave off some more runtime but NP-hard problems like day 23 are look pretty intractable. 
It's been pretty easy to optimise memory usage to get results comparable to some of the C++/Rust solutions on the subreddit. Still annoying that string slices are expensive instead of reading into existing memory. Need to understand Views better to fix that.   

Finally - and this is the important thing for AoC langauges - no new language feature that jumped out to me. Zig had native option and error types, Crystal had the Ruby-style syntax etc. I guess Nim had the friendly syntax, but it feels like it sits in a happy medium of multiple languages with no USP of note. It's not an issue - good and consistent design choices are important - I just didn't scratch that newFeature (TM) itch.


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

### Day 01 - Speed up
No need to mutate the string in the end. `continuesWith`` does the string comparison at an offset.
Weirdly declaring a variable for readability causes a 30% slowdown from 550µs to 700µs. All it takes is the following change in simplified code:
```nim
for n, numStr in ["one", "two", "three"]:
    if str[i].ord == ('0'.ord + n + 1): 
        if firstNum == -1:
            firstNum = n + 1
        lastNum = n + 1
```
to
```nim
for n, numStr in ["one", "two", "three"]:
    let m = n + 1 # Temp var to capture n + 1
    if str[i].ord == ('0'.ord + m): 
        if firstNum == -1:
            firstNum = m
        lastNum = m
```
This should be a simple case of variable elimination? Curious as to what's happening here.

## Day 02 - Cube Conundrum
~~Time to sort out regex parsing.~~  
edit: Turns out using repeated capture groups are a minor-grade nightmare in Nim. First up we have the `std/re` package. Does regex matching, cool, but requires the capture group structure be passed in to the `match` function as a pre-allocated array. Hard to know the size of the array if we're trying to capture an arbitrary number of capture groups, no?  

`Nim: 1 Repeated Captures: 0`  

Up next is the `std/nre` package. (Insert diversion here about only having one official package in the stdlib). It's better since captures can be converted into a seq, but the library uses the PCRE implementation of regex and PCRE decided the best way to handle repeated capture groups is to throw away all matches other than the last one. I see `"abcd".match(re"(\w)+")` and expect `["a", "b", "c", "d"]`, PCRE gives me `["d"]`. Jesus.  

`Nim: 2 Repeated Captures: 0`  

The `std/nre` docs recommend two other user regex libraries, so we're now up to four options, and I checked the first to see it's also PCRE. Didn't bother checking the last one.  

`Nim: 3 Repeated Captures: 0`  

Three strikes, you're out. Lessons learned for today are to stay far, far away from PCRE and to be happy with manual string manip I guess.  
Gonna use `nre` for future regex tasks, excepting the above issues. Even a simple useage doubles to runtime of Day 02 so not using it here. Also need to keep in mind that imports must use `import std/nre except toSeq` since `nre` breaks the normal `sequtils.toSeq` implementation. Sigh.

On the bright side, pattern matching! Currently not in the stdlib, but apparently scheduled for it. It's just for array destructuring and syntax isn't quite as clean as Haskell, but still very nice to have. Supporting int sizes larger than 64bit also seemed like an issue for a moment, but that was me defaulting counters to `low(int) == -9223372036854775808` instead of zero.

## Day 03 - Gear Ratios
**Unbelievably** annoyed by this one. If a number is adjacent to two symbols it gets counted twice. Absolutely nothing in the spec that indicates this should be the case. Docs said sum all parts. Why would a single number next to two symbols be considered two parts??

## Day 04 - Scratchcards
Not much to report. Set, set, intersect.  
The parseInt calls may seem extraneous, but int comparison is much faster than string comp, so this results in a 33% speedup.

## Day 05 - If You Give A Seed A Fertilizer
I swear this year was custom built to kick my ass. Range intersections and splits on day 05? Pain.
Also of note I've been using `.insert` for appending to `seq`s when I should have been using `add`. To fix later.

## Day 06 - Wait For It
Brute force ftw. Shame I couldn't start this one time since it was one of my faster times to get the gold star.
~~There's gonna be a simple mathematical formula for this one after cleaning up.~~ Quadratic equation. If we remove the input parsing logic then execution time is sub 1 nanosecond and my benchmarking code breaks. Is Nim doing comptime evaluation for me?

## Day 07 - Camel Cards
When in doubt, lexicographically tuple sort it out.
A lot of fighting with Nim due to lack of familiarity:
- getting confused by the error when I used `sort` which doesn't return instead of `sorted` which does
- Trying to figure out which types get comparison for free
- How to create a custom comparator for sort
But a 3:20 turnaround from silver to gold star might be my fastest result yet, placing in the top 1000 and second(?) highest placing from any year.

Clean up: Applying scores inside the comparison function << applying scores then comparing. Fewer stack pus and pops probably.  
Still need to get it under 1 ms which will probably come from the frequency computation that is `O(numCardsVals * lenHand)` instead of `O(lenHand)`. I'm not sure why but `sorted(SortOrder.Descending)` seems to be consistently slower than `sorted(SortOrder.Ascending)` by a small amount

Speed up: Juuust snuck it under 1 ms by changing an `array.sort; [@most, @second] := array[0..1]` into a linear scan of the array for the highest two vals. Less pretty, but shaves off that needed 0.5 ms.

## Day 08 - Haunted Wasteland
Nothing to report. Some unclear compiler warnings due to using `input.lines` instead of `input.splitLines`

Clean up: Use ints instead of strings for equality checks. Use native set type. ~~Still over 1 ms though.~~ Why use a hashtable at all? nodes are limited to strings of len 3, so there's a max of 17,576 possible inputs. Just stick it in a static array

## Day 09 - Mirage Maintenance
Slow start but quick turnaround for the gold star. This feels like it's just derivatives? Wonder if there's a non-stack based solution here.

Clean up: Turns out Nim `func`s aren't pure functions and allow for mutation of arguments passed in. I was confused why the compiler wasn't doing common subexpression elimination for recursive calls to `nextDeltas` [here](./src/days/day09.nim#L14) and needed to save the result into a variable first. 

The following line
`return (bar.mapIt(it[0]).sum, bar.mapIt(it[1])..sum)`
reports only the error
`SIGSEGV: Illegal storage access. (Attempt to read from nil?)`
`mapIt` is a macro, and while Nim promises less awful macros than C this looks like a case where they still aren't great.  
Accidental `..` when accessing a field? SEGV is a *weird8 message to be returned.

## Day 10 - Pipe Maze
Map parsing, pathfinding, floodfill which can bypass neighbours?  
bruh

## Day 11 - Cosmic Expansion
Always helps to read the damn prompt correctly. I saw "sum of shortests paths" and somehow read Travelling Salesman problem.  
Here's a fun perf note. Changing
`let manhattan = (starA.r.abs - starB.r.abs).abs + (starA.c.abs - starB.c.abs).abs`
to 
`let manhattan = (starA.r - starB.r).abs + (starA.c - starB.c).abs`
results in a 42% **slow down**. Are the extra `abs` calls giving useful type hints?

## Day 12 - Hot Springs
I'm phoning it in on the clean up and optimisation atm. First day that ends up over 1 millisecond. Will come back to this later when there's more time and energy.  
It's always surprisingly expensive to use slicing in Nim. Using
```nim
let hasSpace = line[lineIndex ..< lineIndex + springLen].all(x => x != '.')
```
instead of 
```nim
var hasSpace = true
for i in lineIndex ..< lineIndex + springLen:
    if line[i] == '.':
        hasSpace = false
        break
```
results in a 25% slowdown. I assume that slicing creates a copy of the data under the assumption the slice can/will be mutated?
The docs mentions slices are an object so perhaps we're spending a lot of time creating them.

## Day 13 - Point of Incidence
Made a mistake where if rows `i` and `i - 1` were mirrored I tried checking all remaining rows for mirroring, but checked `i` and `i - 1` again and result smudge correction was double counted. Lucky that the example input caught that.  
Nim's flexible syntax (`foo.bar(baz)`, `foo(bar, baz)`, `foo.bar baz`) has been really nice so far. Not great for a industrialised code base, but great for scripting like AoC.

## Day 14: Parabolic Reflector Dish
Using hashes is coming in at a chunky half second. Need to clean up the maths to skip to the 1000000000th iter since the first attempts at modulo math were playing up. I ended up throwing in a random -1 to make things work so I need to think on where the off by one is coming from.  
edit post clean up: Completely wrong on the hash theory. Changing from moving rocks one space at a time to instead moving as far as they could go shaved off 80% of the runtime and using modulo maths instead of skip counting up to 1000000000 removed another 10%. Code is a bit messy but runtime is down to 15 ms. More to come.

## Day 15: Lens Library
Spent more time trying to understand the part 2 prompt than I did writing up part 1. Could've been a good placement if I'd started on time. First time that the code clean up has resulted in slower code. Still under 1 ms though and a 20% slowdown for 50% less code seems fair enough.

## Day 16: The Floor Will Be Lava
Pathfinding. Par for the course.  
300ms seems slow for the input though, to check. Caching `state => explored cells` seems like a good start.  
Step 1: Remove the hashtable and use an allocated array instead. Half the runtime.  
Step 2: Remove the queue for next to explore. Instead track current state in the loop and spin off a subfunc when hitting a splitter.  
Step 3: Instead of 4 bools to determine entry directions for a cell use a bitmap.  
Current runtime 20ms. 19 to go(?)

## Day 17: Clumsy Crucible
Had a chance to start on time for the first time in a week. Got everything prepped, had all the files and inputs ready to go, and 4 minutes in I get a phone call that lasts an hour `¯\_(ツ)_/¯`.  
Wasted a whoole lot of time not including `curForwardCount` in the explored array and was truncating search paths that were valid. Paaaaaaaain. A* is meant to be easy to implement. Even with all that still in the top 3000?  
Up next - or at some point in the future - making this run in under 8(!!!) seconds. Without release mode we're up over a minute(!!!!!!) My benchmarking code reports `inf s` because I didn't allow for >5 second runtimes.  

Step 1:  
Remove the debug code that tracked historical path through the grid. Duh. 95% time saving down to a 500ms runtime.  

Step 2:  
Walk forward all possible distances in a single loop. Don't go one-by-one. No big wins here, but easier to reason about.  

Step 3:  
`680,000` and `1,552,000` nodes explored for P1 and P2 respectively. Instead of treating moving forward and turning as separate acts (we'd pop a state that had  previously moved only to push two turns with identical predicted cost back to the queue. These states have identical predicted cost and will be right back at the start of the queue to be popped immediately) do it all at once. This also removes the need to track `curForwardCount` at all. Total explored nodes drops by 33% down to `452,201` and `1,034,139`. Runtime halved to 200ms, but there was some transient variance up to 270ms that no longer replicates. Might need to `nice` the process in future?  

Step 4:  
Prune search nodes *before* inserting into the queue. New explored nodes `130,000` and `171,000`. Runtime only down by 35% though: 130ms.  

Interlude:  
Hit a compilation error out of nowhere:
```
error: error: error: error: unable to open output file '/Users/ajmorton/.cache/nim/aoc_2023_nim_r/@m..@s..@s..@s..@s..@s..@sopt@shomebrew@sCellar@snim@s2.0.0_1@snim@slib@spure@scollections@sheapqueue.nim.c.o': 'Operation not permitted'unable to open output file '/Users/ajmorton/.cache/nim/aoc_2023_nim_r/@mdays@sday17.nim.c.o': 'Operation not permitted'
error: 
11unable to open output file '/Users/ajmorton/.cache/nim/aoc_2023_nim_r/@m..@s..@s..@s..@s..@s..@sopt@shomebrew@sCellar@snim@s2.0.0_1@snim@slib@spure@shashes.nim.c.o': 'Operation not permitted' error error generated generated
```
and only in release mode. `nimble clean` didn't resolve it and had to blow away the `.cache/nim` folder to get things working again.  

Step 5:  
A Bucket Queue shaves off another 20ms.  

Step 6:  
Entering a cell from opposite directions (`Left`, `Right`) results in the same search nodes after turning (`Up`, `Down`). As such the `explored` hashmap only need to track direction orientation (`Vert`, `Horizontal`) rather than all 4 directions. The number of explored nodes is unchanged but this halves the number of hashtable lookups and drops runtime to 80ms.  
Step 7: Replace the `explored` hashmap with an array. No more hashing, runtime halves yet again. 40ms  
Step 8: Turns out the A* heuristic isn't helping runtime(?!). Explored nodes using Dijkstra are only 10,000 more and the extra space/comparison maths must be cancelling that out. Explored nodes is 137,920 and 180,973 respectively.  

## Day 18: Lavaduct Lagoon
TIL Shoelace and Pick's theorem.  
Quick-ish part 1. Created the boundary, flood filled from outside, ~600th position.  
Part 2? Nooooo. Spent the first hour trying to implement something from first principles which was interesting but unproductive. Find out about the above algos from the subreddit and get confused af trying to understand them. At least the final result will be fast.

String slices continue to be annoying. Why allocate new memory for a read-only access into a string?  
The experimental [Views](https://nim-lang.org/docs/manual_experimental.html#view-types) type promises to fix this but it's not clear how to implement for string slicing.

## Day 19: Aplenty
BuT iT wOrKs On ThE tEsT iNpUt.  
Surprised it took so long to run into this.  

Got taken out by a single copy paste error in the massive eval function. Should've caught that faster.
Compacting this down will be fun. Starting at 206 lines which is over double anything not named day10.

Took a bit to slip under 1ms. In general: Avoid regex, if `split(sep)` produces only two results then prefer `find(sep)` and split on the separator index manually.
Also apparently
```nim
return case foo
  of 'A': 1
  of 'B': 2
```
is slower than
```nim
case foo
  of 'A': return 1
  of 'B': return 2
```
Surely this is a simple compiler optimisation?

Still ~100 lines long. The lack of python's `eval` is really biting here. If the checks were > and <= then it my `eval` func could be halved in size with a bit of effort. Alas.

## Day 20: Pulse Propagation
It's been a while since a good reverse engineering problem. Initially looked one level deeper than the 4 components in the code comment. Clearly some counters going on in there when watching the bits flip every cycle. Instead take the easy solution of checking the 4 Conjunction components and eay the 200ms time cost for now. Getting this fast will be a question of input analysis rather than code optimisation.

## Day 21: Step Counter
80 minutes for the first 100 finishes today. Gotta be a new record.  
Part 1 was fast and easy, but part 2 is **rough**. I think it's important that all the edges of the map are empty space. Current theory: Build up a map of distances from all edges. Use that to determine the diameter of the bounding circle. All fully contained squares can be counted and multiplied, then do the edges manually. No idea if this works, but an interesting problem.

Ended up going to the subreddit for solutions, but I would've needed to notice that there are empty cells in both the vertical and horizontal directions from the start, and also intuit that there's a computable sequence every 131 (grid height and width) steps. Not sure how this works. Doesn't this imply some sort of radial symmetry? Either way slowest solution to date and I don't see many paths to get this under 1ms.

Clean up: I was **not** expecting to get this under 1ms, let alone a third of that.  

Step 1:  
Let somebody smarter than me figure out the geometric solution: 6.5ms  

Step 2:  
Replace the HashTable with a 2D array: 4ms  

Step 3:  
Stop popping from the queue and inserting at the beginning. Instead insert at the end of the array and walk a pointer through the array from the beginning - intentionally not removing explored points - until it reaches the end. This removes O(n) operations for inerting an item at the beginning of the array which shuffles all points back one position. 330µs

## Day 22: Sand Slabs
Nothing to report. 3D tetris  
Clean up: IntSet is faster than HashSet, however it produces a deprecated warning
`/opt/homebrew/Cellar/nim/2.0.0_1/nim/lib/std/packedsets.nim(465, 10) Warning: assign is deprecated [Deprecated]`
Annoying since this is in the standard library

## Day 23: A Long Walk
Made a stupid mistake when building connections by marking nodes explored slightly too early. Burnt a good hour and a half on debugging it because it only appeared in a very specific edge case.  
J   
F   
C  
Didn't pop up until I walked through every single connection point one by one. Must've looked over the connection graph 5 times before finding it and the code was only ~120 lines. I introduced it after solving part 1 as well for bonus pain.

Code is in an awful state atm and 16 seconds to run. Deal with that later. Since this is AoC there'll be a way to get runtime down. There's probably a node N which will partition the graph when removed. Then finding the longest paths `start -> N` and `n -> end` can be summed for the total path and drastically cut the search space.

Speed up:  
A lot of effort to get this down to ~215 ms and the code is **ugly**. My 1 millisecond per day goal is in rough shape.  
Steps to bring runtime down are as follows:  

Step 1:  
Avoid anything with a dynamic size. An `array[4, Foo]` which null fields is faster to iterate over than a `seq[Foo]` of length 1 or 2. Make sure to check for null vals properly.  

Step 2:  
No hashing where possible. HashSets also become `array`s with a bit of effort to convert keys into a simple integer so we can index into the array.  

Step 3:  
Continuing from 2) sets can be replaced with bitmaps, and bitmaps with integers if the set is small enough. Nim has native `set`s, and `intset`s but both are slower than sticking everything into an `int64`. This needed heavy effort to prune the conenction graphs to under 64 nodes (both have 36), particularly for part1 where the connections aren't symmetric.  

Step 4:  
One the nodes have been processed there's no need to track their original loction in the array and an `(int, int)` position can become a `int` posId. The connection building logic is much larger than the traversal. Blah blah sharpen axe three hours cut for one.  

Step 5:  
Reducing the size of types slowed things down? Tried changing `Conn` from two `int`s into two `int32`s so that it would fit in a single machine word. This causes a 10ms slowdown. Then tried `int16` and this slowed it down by 15ms. Perhaps the int conversions are expensive? Everything is single-threaded so there's no cache line contention and smaller types should mean fewer cache misses. The connections array is 2kB using `int64` and 512 bytes using `int16`, and `sysctl` tells me I have 64kB of L1d cache so everything fits in L1 regardless I guess.

Step 6:  
Even after all this there's still 30,580,294 nodes being explored. Any node pruning feels like it'll be speculative and not provably correct. I don't see any obvious wins on this front, and this'll obviously be the next step to improve runtime. edit: Exploit the fact that the endPoint is only connected to a single node, and therefore any path that enters this node must travel directly to the end pos, otherwise the end pos is unreachable. Drops the state space by 40% and runtime along with it. 125 ms.

Step 7:  
Finally needed to bring in `{.experimental: "parallel".}`. 64 threads -> 4x speedup. Not sure why 64 is the magic number here since this laptop has 4 cores and no hyperthreading.

## Day 24: Never Tell Me The Odds
Simple algebra for part 1. Part 2 was a slog. Seeing a lot of solutions using Z3, but that defeats the point of AoC imo.  
Floating point caused some real hairy issues today and I've written the world's worst equality check with the `~~=` function. Part 2 is now done and cleanup to come soon-ish(?).

## Day 25: Snowverload
Not too enthused by the past two days since they both just required plugging the problem into an external library.  
Still need to write up a proper solution since the current one uses randomness until we're lucky enough to pick three pairs of nodes that cross the minCut boundary. Runtime is... long. 35 seconds? 35 minutes? We'll never really know.

Speed up:  
Much simpler solution making use of the fact that we know the minCur lengths is 3. Way faster, way neater. 
Sub 1 ms looks within reach. edit: Turns out the flood fill portion is both slow and unnecessary. Just track explored nodes in the dijkstra searches.