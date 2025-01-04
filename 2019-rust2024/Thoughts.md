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