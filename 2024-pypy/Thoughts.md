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