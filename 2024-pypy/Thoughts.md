# Thoughts on PyPy 3.10

## Day 00 - Setting up the framework
Not happy to be using a prior language this year. I left things late due to other priorities and today's attempts with Mojo were underwhelming. It's missing a tonne of convenience functions (list comprehension, f-strings) and for a language that promises dynamic typing I sure ran into a tonne of type system errors. Whatever. On we move.  

If I had more time I'd try Gleam, OCaml or maybe Borgo which popped up on Hacker News earlier this week. But here we are a few hours before day01 drops.  

So, back to Python. I guess that means this years goal is chasing the leaderboard (a couple of top 500 places would be nice) and we'll see how much perf we can squeeze out of Python. For that reason this year we try PyPy (also I get to call the folder 2024-pypy and pretend it's not identical to 2020-python)

Not much to set up this year. Copy/paste from 2020 and update to perform (slightly) better benchmarking

## Day 01 - Historian Hysteria
Split, sort, compare, and sum. No notes.

## Day 02 - Red-Nosed Reports
(581/1016) isn't terrible but it comes with the asterisk of the AoC servers returning 500 errors. Tried to refactor part 1 instead of copy-pasting it for part 2 which cost me a minute or two.

## Day 03 - Mull It Over
(410/5285) The example was a single line and the input was multiple so I didn't reset the `do` flag on each line.  
Fucking.  
Brutal.

Todays lesson is to read the goddamn input, which I should know after literally years of AoC. Lost a couple of minutes not realising that part two had updated the example string. Lost **a lot** of minutes treating my input as one line when it was split across multiple lines. Ever more so because I took a shortcut and used `for line in lines` as a shortcut.
Paying attention: 1  
Andrew: 0

## Day 04 - Ceres Search
Another day of stupid mistakes. reverse(XMAS) != SAXM.  
Not very golfy today. It can get shorter with dicts but that adds a 20x slowdown. Hard to explain why I care about this in Python of all languages but here we are.  
Today was a good reminder to make use of complex number for indices and `dict.get(pos, default_val)` in future days rather than handling annoying OOB accesses.

## Day 05 - Print Queue
Not  
Happy
Jan  

1) Started P2 with a brute force permutation: Slow, didn't bother waiting.
2) I know, let's create a DAG out of the page orders. Input was intentionally seeded with a cycle. Fuck.
3) Custom partially ordered sort function? Works I guess

If this years theme is malicious input I'mma live life on tilt.

# Day 06 - Guard Gallivant
Brute forced part 2 for a 38.44 second(!) runtime. There's probably a simple loop finder where you track the last 3 collisions and see if you can insert a blocker at
```
new_blocker_pos = third_last.x + 1 + current.y
```
allowing for current rotation.

Will play around with this later. Only part 1 is 4.35ms so breaking 1ms will be tricky.  
edit: This idea only works for simple loops. Instead: 
- Stop using a default dict for the grid. Use a 2D grid instead
- Stop using complex numbers. Do the rotation and movement logic manually using ints
- Don't run the simulation for all possible blockers. Only run it for blockers on the walked path from part 1 (Important! Make sure that the spot and direction we're testing can be reached with the new blocker placed. e.g. if we're on the part 1 path at ((3,5) Up) we would want to place the blocker at ((2,5) Up), but maybe placing the blocker at (2,5) means we can no longer reach ((2,5), Up) using the original P1 path.
- Copy nothing. No need to copy the grid as it's now read-only and can be passed throug. No copying the visited hashmap, we start new on each subfunction call.
- The visited grid is sparse enough that a set works better than a 2D grid for all cells.
- NameTuples are bloody slow. 3x slowdown compared to a normal tuple indexed with foo[0]

So far this is 1n 86x speedup. Annoyed I can't hit 100x

# Day 07 - Bridge Repair
Go read itertools. Plug in values. Meh. I guess I should write the memoises version at some point.  

edit: There we go, back under a millisecond. 3000x speedup for the memoised recursive impl. @functools.cache is a tiny cheat but I assume a handrolled dict gets similar results. Reversing the string cat was a fun one to think about.