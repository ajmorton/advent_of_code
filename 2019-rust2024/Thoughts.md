# Thoughts on Rust 2024

## Day 00 - Initial setup
Broken Window Theory is real people. I do a second year of Python and here we are straight back to Rust. Apparently it's been 3 years (and 1 day) since the last sortie. We'll see how much I remember. This also has the added benefit of maybe possibly potentially coming in useful for work related reasons 👀. We shall see.

Bit of a cheat to start with. Just stole the folder structure from 2018 including criterion for benchmarking. As always cargo is nice, but we're already at 61 dependencies so we're certainly off to a dependable (ha) start.

## Day 1: The Tyranny of the Rocket Equation
I forgot how good Rust error messages are. Exact line, exact issue, a link for further info and the proposed solution all in one. B-e-a-utiful. Runtime is already down to 2 µs which bodes well Including the input in the binary removes the entire I/O cost though, so arguable not generic across all inputs. I think I'll chase a total time of < 50ms for this year.  

I've missed the lamda syntax (or closure or w/e they're called in Rust), just the right level of concise.  
Using a chain of `.map()` and `.sum()` squeezes out an extra 40% perf over a normal for loop. It must give the compiler more leeway for optimisation. [Compiler explorer](https://godbolt.org/#g:!((g:!((g:!((h:codeEditor,i:(filename:'1',fontScale:14,fontUsePx:'0',j:1,lang:rust,selection:(endColumn:5,endLineNumber:12,positionColumn:5,positionLineNumber:12,selectionStartColumn:5,selectionStartLineNumber:12,startColumn:5,startLineNumber:12),source:'fn+fuel_cost(weight:+isize)+-%3E+isize+%7B%0A++++weight+/+3+-+2%0A%7D%0A%0Afn+fuel_cost_rec(weight:+isize)+-%3E+isize+%7B%0A++++let+fuel_weight+%3D+weight+/+3+-+2%3B%0A++++if+fuel_weight+%3C%3D+0+%7B+0+%7D+else+%7B+fuel_weight+%2B+fuel_cost_rec(fuel_weight)+%7D%0A%7D%0A%0A%23%5Bmust_use%5D%0Apub+fn+run(input:+%26str)+-%3E+(isize,+isize)+%7B%0A++++input%0A++++++++.lines()%0A++++++++.map(%7Cx%7C+x.parse::%3Cisize%3E().unwrap())%0A++++++++.map(%7Cw%7C+(fuel_cost(w),+fuel_cost_rec(w)))%0A++++++++.fold((0,+0),+%7Cl,+r%7C+(l.0+%2B+r.0,+l.1+%2B+r.1))%0A%7D%0A'),l:'5',n:'0',o:'Rust+source+%231',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0'),(g:!((h:compiler,i:(compiler:r1830,filters:(b:'0',binary:'1',binaryObject:'1',commentOnly:'0',debugCalls:'1',demangle:'0',directives:'0',execute:'1',intel:'0',libraryCode:'0',trim:'1',verboseDemangling:'0'),flagsViewOpen:'1',fontScale:14,fontUsePx:'0',j:1,lang:rust,libs:!(),options:'',overrides:!(),selection:(endColumn:1,endLineNumber:1,positionColumn:1,positionLineNumber:1,selectionStartColumn:1,selectionStartLineNumber:1,startColumn:1,startLineNumber:1),source:1),l:'5',n:'0',o:'+rustc+1.83.0+(Editor+%231)',t:'0')),k:50,l:'4',n:'0',o:'',s:0,t:'0')),l:'2',n:'0',o:'',t:'0')),version:4) certainly looks chunky with over 1,600(!) lines of assembly.

## Day 2: 1202 Program Alarm
And now the borrow checker starts to appear. `prog[prog[pc+3]] = prog[prog[pc+1]] + prog[prog[pc+2]]` should work, we need to store the internal `prog[pc]` in an interim var. Bit annoying. I know IntCode's going to be a staple for the rest of the year. Time to look into proper structs.

## Day 2.5: Add flamegraphs
ok this is **very** impressive. Install one cargo dependency, spend a few minutes reading the docs, and flamegraph runs - on a mac no less - with zero diffculties. I'm so used to stringing together my own script to hook the perf output into the .pl files. Cargo is 🔥💯🔥.  

For the downsides there's already 128 dependencies and full compilation time of my, what, 200 lines of rust is 13 seconds (21 seconds in release). Incremental builds fix this, but it's a bit of a concern.

## Day 3: Crossed Wires
First time in the milliseconds. The default HashMap is cryptographically secure so changing the hashing policy should take care of that. This is also the first day where string handling got a bit icky. It's reasonable as Rust strings support UTF-8, but it's still annoying you can't index an ASCII string with `foo[0]`.  

edit: Nope, only 70% faster for a 4ms runtime. This can go under 1ms but it'll probably need to drop the hashmap and compute intersections of the extents. The complexity goes from O(len_w1 + len_w2) to O(len_w1 * len_w2) but removing the hashing overhead should win out. Come back to this at the end.  

It's a weird choice not to support a quick/unsafe hashing polocy in the stdlib hashmap and requiring a 3rd party AHash library. I guess the friction prevents devs from taking a shortcut in code that does need safety? 

## Day 4: Secure Container
No need to speed this up. I'm gonna claim that I'm loop unrolling and not that I hard coded all conditions.

## Day 5: Sunny with a Chance of Asteroids
😩  
The arguments are always param mode Pos. You only Imm them when accessing the value they point to. So much debugging on that assuming my param modes logic was wrong.
Ran into the borrow checker a few times. It's annoying passing an isize into a function taking &isize doesn't autopromote it. I can't see any reason not to do so. Hopefully future IntCode days don't require futher re-engineering of old days like today did with day 02. It's also done a number on my day 02 runtime which is annoying. I guess I'll trade that for a blazing fast day 05. For now.

edit: There we go. No suprise mallocing all those vectors took so long. Also dropping the safe casts from usize to isize. It's pretty obvious when we pass a negative number and try access the array at MAX_INT. Still a bit of a slowdown but day 02 is back under 1ms so all is forgiven.

## Day 6: Universal Orbit Map
Kinda messy. No need for a hashset in the orbiting map as there's only ever one parent. Eh, fix it in a mo.
edit: Pretty straight forward. Get replace hashmaps with vectors, replace HashSet with a vector. Computer go fast.

## Day 7: Amplification Circuit
This day is very cool. Hooking together multiple computers to build a larger system? The rest of the year looks promising.
This is also blazingly fast given there are 1200 vector clones taking place. I don't know what rust is doing under the hood but that's 4.8MB copied in less than 400 µs.

## Day 8: Space Image Format
These visualisation tasks are always my fave. Not much to report here other than we're looking very good for the < 50ms target. It's interesting that three independent `iter().filter(|x| x == '1').count()` loops is 20% faster than inserting a counter into the existing `for pixel in layer` loop. There should be 3 times fewer iterations. Either the branching causes mispredicts or Rust really prefers chaining calls on iters when it comes to optimisation. 

edit: Yeah these iterators go fast. 25% speedup on an already speedy 40µs run by converting a for loop into an iterator. I wouldn't claim improved readability, but we're here for the µs BB. 

## Day 9.0: Rework parameter modes
The IntCode giveth, and the IntCode breaketh your face. No wonder I was struggling to get the parameter modes working. Inputs and outputs need to be treated differently since we're storing into the output which requires an additional access to memory that you can't compute at the same time as you compute the inputs (since they can become immediates). The existing code was jank and mixed and matched parameter accesses and direct memory accesses. That's now thankfully gone and future changes should be much easier.

## Day 9: Sensor Boost
Easy once I'd fixed the gd parameter modes above. BigInts slow down my day 02 to over a millisecond though, grumble grumble. It's been a while since I used a language with an proper type system. It's so nice to make a type change and have the language server points me at all the places that need updating. It missed a few places where we're using ints that cast to enums, but that's expected. I've probably made too many things i128. To check and see if we can keep the IntComputer fast.

edit: I guess 64 bits counts as BigInts these days? w/e I'll take it. Still a factor of 2 away from my sub millisecond runtimes. Why does rust shout at me when I use branch prediction hints? I know what I'm doing. Probably. Either way likely_stable saves the day.

## Day 10: Monitoring Station
:|  
Fiddling with the atan2 math was painful. So many tweaks just to reverse direction and rotate by 90 degrees. Couple that with my inability to understand `100*x + y` != `100*y + x` and we're gonna have a bad time.
2ms. I guess that's fine for now unless there's obvious time saves.

## Day 11: Space Police
Not much to say other than when copy-pasting the code from day 09 I forgot to remove the initial inputs. Code was fine otherwise.

## Day 12: The N-Body Problem
35 ms 💀💀💀  
Should only need to run ~6000 steps for this. This actually feels kinda slow..  
In other news this is the first day of regex(!?) and hitting the borrow checker properly where I wanted to iterate of array items while mutating them. Indexing works but it's a bit of a mental jump to go from the iterator first model to now needing indexing like some kind of C programmer.  
A majority of time is spent on the hashset insertions. I expect `contains()` is also there but not being shown in the flamegraph. A 6D array is gonna be sizeable.. tbd on how we 86 the hashset.  

edit: Somebody smarter than me realised that the system is fully deterministic so each state leads to exactly one future state and is deribed from exactly one previous state. This means if there's a loop we're already in it and only need to check when we first reach the original system state. Coincidentally my original impl utilised this without knowing. I should've had some check to remove a non-looping set of initial states.  
5ms? Not great but we're probably on track for sub 50ms.

## Day 13: Care Package
Yeah this is cool. I wonder who wrote a fully fledged brick breaker game in IntCode of all things? Hope they had a an interpreter.

## Day 14: Space Stoichiometry
I did **not** vibe with this at all. Even the string parsing gave me a headache.
Part 2 still needs a proper solution. It was solved by a manual binary search with a bunch of guesses and printlns.  
The current time of 40µs isn't accurate but it'll still be under a millisecond provided I can binary search part 2 in under 25 attempts.

## Day 15: Oxygen System
I didn't expect this to come in under a millisecond. I just spammed hashmaps and sets everywhere. Copying the compute as part of the state was a cool idea. I wan't looking forward to implementing backtracking all over the place.  
edit: This doesn't make sense. 3,308 `clone`s, 3250 `insert`s, 6390 `contain`s makes for a lot of hashing and memcopies. Half the runtime is spent inside the IntComputer(!!). Is AHash smart enough to recognise the key is (isize, isize) and use a fast hash? This is way faster than it should be.

Some cleanup to do. Will probably come back to it when all days are finished.

## Day 16: Flawed Frequency Transmission
I saw `Flawed Frequency Transmission` and immediately knew it was Fast Fourier transforms. Turns out my ElEng degreee will be used for precisely one thing. Didn't really care for today, and worst of all it's *slow*. I'll need to come back to this but definitely at a later date.

## Day 17: Set and Forget
Manual solution to P2. I can't imagine anyone's found a programatic solution.
Code is messy but don't want to fight with the IntComputer interface right now. As per the previous days will clean up later once everything is solved.

## Day 18: Many-Worlds Interpretation
😮‍💨

## Day 19: Tractor Beam
Easier day to follow 18

## Day 20: Donut Maze
On the one hand, this problem is cool. On the other, this problem is proper effort.
It's pretty cool I can just submit the first P2 result when the program compiles and it's the correct solution. Very flowy.  
I reckon I can get this down to 10ms with some effort. I'm not seeing a path to sub 1ms.

## Day 21: Springdroid Adventure
Pretty much just guess and check today. You could do it programatically but not really worth the effort.

## Day 22: Slam Shuffle
I'm not a fan of the modular maths questions. There's always very specific knowledge required and I've written implementations of it I'm not interested in writing another. Perhaps I come back to it later but today is not the day. 1234 is a cool number for part 1 at least and we're finally back under a millisecond ever though my part 1 solution is Not Good(TM).

## Day 23: Category Six
Simulating a network of independent agents? Also very cool. Some of the requirements are vague enough I wouldn't want to be chasing the leaderboard, but doing this at a casual pace is definitely worth it. It's a shame IntCode died after one year, but I can see where it has some friction points given the target audience.

## Day 23.5: Clippy
Clippy can see this
```rust
} else if line.starts_with("cut ") {
    let cut: isize = line[4..].parse().unwrap();
```
and know I actually wanted to do
```rust
} else if let Some(<stripped>) = line.strip_prefix("cut ") {
    let cut: isize = <stripped>.parse().unwrap();
```
This is very impressive. Even if it's a handwritten edge case someone's put in the effort to find exactly this. I wasn't expecting to find new language feature I liked this time round since I've reused Python and Rust, but I have a new appreciation for clippy and I don't think I've seen anything comparable in other languages. Linters sure, but not to this level where it's adivising proper use of a stlib function (and giving the exact changes). It's robust too. I can stick arbitrary code in between the two lines and it still finds the exact change to make.  

Digging into it clippy identifies the improvement based on the length of `"cur "` and the fact I've made a same-sized slice on the following lines. Intelligent parsing like this sounds *crazy* powerful. 10/10

I don't know I agree with all of the suggestions such as
```rust
for r in 0..height {
```
changing to
```rust
for (r, <item>) in grid.iter().enumerate().take(height) {
```
It's dubious that this is clearer in its intent

## Day 24: Planet of Discord
This manual listing of neighbours in vecs is slow. I can move the counting logic inside the subfunc and that should be better. But this code feels ugly. At least we've avoided a hashmap.