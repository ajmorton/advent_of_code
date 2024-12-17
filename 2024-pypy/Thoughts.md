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

# Day 08 - Resonant Collinearity
Good day. 00:07:47/413, 00:12:45/420
Runtime is already well under a millisecond. Just golf the code and be done with it. There's a linear equations solution in this but the current code performs approx 2000 checks so it's not getting faster than that.

# Day 09 - Disk Fragmenter
Another good day with 00:08:00/231, 00:29:25/606. New PB on the silver star and probably top 200 if you only count the legitimate (read: non-LLM) times.  
Started with a simple insertion sort for part 1 and then had to migrate to extent lists for part 2. There's a fun little pattern where my loop vars were k,j,i instead of i,j,k as I realised I needed an earlier loop twice. Part 2 worked on the first execution which was a nice surprise.  

15ms is the slowest day so far. Would like to get that under 10 later on. Saved an extra 40% of runtime by removing the redundant -1 block ID from the holes list, so less tuple destructing is a good candidate.

# Day 10 - Hoof It
Bad day for reading comprehension. Height must **always** increase by 1, not increase by at most 1.
Surprised that part 2 was so trivial. Literally just drop the seen list and count the number of times we hit a 9. We should be entering the point where efficient code is required.  
Although the code runs in 15ms unoptimised.. Eh, c'est la vie.

# Day 11 - Plutonian Pebbles
15.9µs 🔥🔥🔥.
Brute for part 1 and the a quick rewrite to a recursive impl. Don't think there's much cleanup to do today.  

`@functools.cache` is straight up cheating today. Without the magic line the first stone (not even solution) still hasn't finished after 30 minutes. Today's clean up is actually marginally slower, but what's a quarter of a microsecond between friends? 

# Day 12 - Garden Groups
Tricky one. Thought up an approach relatively quickly but then wasted a tonne of time because I tried a short cut of using  
`for dirr, neighbour in enumerate([next_pos + 1j, next_pos -1j, next_pos +1, next_pos - 1]):`  
so directions were indices `0`,`1`,`2`,`3` but then checked the directions using complex nums  
`for dirr in [0, 1]:`  
2.9 seconds ain't grand. Writing a smarter edge finding logic is gonna be rough with those internal boundaries

edit: The code's pretty jank, but 6ms is in the acceptable range. Didn't come up with the corners solution myself, but I do recognise it from previous years. It's just one of those AoC trivia items I guess. Here's hoping there's no Chinese Remainder Theorem this year.

# Day 13 - Claw Contraption
Well that was an absolute schemozzle. Started with recursive solution; Slow but got part 1 ok.
And then I knew it was linear equations, and I had to use my own brain(?!?!?!). Very unfair.
Started hitting precision issues I think, but they went away when I stuck the code into a subfunction? Must've typod somewhere and not noticed the fix.

First day over an hour. Should've been able to do that faster. The code is absolutely awful as well

# Day 14 - Restroom Redoubt
I don't know how to do this one without manual review. I mean I had to guess that the tree pattern would contain a straight line based on the presence of a tree trunk. I also tried "All robuts are adjacent" under the assumption every single point was part of the image which wouldn't have worked, and then spent 15 minutes trying to get the console output to process in a clean way to manually review (101 * 103) possible frames. Is this just a case of make an assumption and check visually? Kinda hard to benchmark a generalised solution here.

Today's speedups:
- Stop printing everything
- Find out there's a hidden assumption the hidden pattern appears the first time no robots overlap. Given the grid was 101 by 103 there must be some prime number theory involved. Not a reasonable assumption to make on first viewing of the problem though. This removes a bunch of checking and simplifies the check to checking for dupes in a list
- Good old generational `seen` array
- Skipping work that we know is redundant

Under 10ms which is the current target. Good enough for now.

# Day 15 - Warehouse Woes
:|

# Day 16 - Reindeer Maze
Absolutely terrible. Christ.  
There's at least 2 bugs playing into each other. Mixed and matched the pruning logic in a way that flip flopped between pruning too much and not pruning things it should have. This should have been a trivial Dijkstra and somehow I spent all this time on A* and node reduction and still took over an hour and half. 
Two bad days in a row and I'll be busy tomorrow.

# Day 17 - Chronospatial Computer
RETURN THE STRING WITH THE COMMAS INCLUDED.16 days of numbers only and I waste a frankly insane amount of time debugging a correct implementation that was written by minute 15. Even worse because emulators are my fave of the puzzles. Add a visit from a tradie and other distractions means todays result is Bad (TM).

Initially tried to reverse engineer the pattern, but all that bit twizzling messed things up. Instead we run for a while reporting the (binary repr) of numbers that produced a longer match to the instructions. The last bits of these numbers tended to repeat in batches of six. To force those last bits and only increment the parent bits. Repeat until P2 falls out.

I don't see any way to produce a generalised solution here. Not even gonna try. Just call it 500ms for now and come back to it later(????)