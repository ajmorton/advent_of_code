# Thoughts from trying Zig

## TODO
- better understand comptime
- stdlib functions
    - std.math.shr
    - std.mem.zeroInit
    - std.meta.eql
- return @Typeof(foo) instead of passing in comptime T arg

## Good
- Getting .map() on Vectors for free is very nice. ArrayList for traditional Java/C++ vectors.
- Types as values is really nice. Super easy generics
    - std.math.maxInt(u32)
- Native doc gen

## Bad
- No default package manager (yet, Zig is still pre-release)
- `zig test` is a bit rough.
    - No way to run all tests
    - Tests are pulled in when the owning file is *used* in a test.
- No traditional for loops is annoying
- Error traces need improvement, 
    - stacks are too big
    - expecting !u32 and seeing u32 (or reverse) prints v. ugly lines 

## Ugly
- 
```
const Point = struct {x: i32, y: i32, z: i32}
var point = {.x = 1, .y = 2, .z = 3};

var x: i32 = 1;
point = switch(x) {
    1 => Point{.x = point.z, .y = point.x, .z = point.y},
    else => point,
}
// returns {.x = 3, .y = 3, .z = 3}
// as this compiles down to 
// p.x = p.z
// p.y = p.x
// p.z = p.y
// instead of an atomic asignment of all fields at once
```


## To check
- syntax for unwrapping optionals. First thought Rust's `if let` seems nicer
- Try out `@shuffle`, esp using ~0, ~1 for the negative indices
- Zig strings are `[]u8`? 
- Enums have static vars?
- Structs and unions have no guaranteed memory layout
- "... one level of dereferencing is done automatically when accessing \[struct\] fields"
- `ArrayLists` have a `.writer()`? Traits seem nicer
- Why use `defer` over desctructors at end of scope/lifetime analysis?