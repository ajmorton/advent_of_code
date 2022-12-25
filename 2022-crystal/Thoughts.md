# Thoughts on Crystal

## Good
- [Documentation support](https://crystal-lang.org/reference/1.6/syntax_and_semantics/documenting_code.html) is excellent.
- Sum types!
- Type inference is aware of things like `if is_a?(String)` and constrains the type inside each branch accordingly
    - This is limited to local vars due to multithreading concerns
- `case` statements for psuedo pattern matching(!)
- Excellent (language reference)[crystal-lang.org/reference/1.6]
- Native regex
- gd do I love function chaining. See Day05's input parsing.

## Eh
- We've got Python-style class attributes, so if they're assigned in the constructor they exist. Explicit listing of (a la `peroperty`) is much nicer.
- If you define a class multiple times it'll merge all class implementations into a single class. We're protected by namespacing but this seems risky.
- [Type inference on tuples](https://crystal-lang.org/reference/1.6/syntax_and_semantics/union_types.html#union-of-tuples-of-the-same-size) is applied to each individual element rather than at the tuple level
- Non-standard try-catch (`begin`/`rescue`/`ensure`) inherited from Ruby.
- Baseline build times are slow (1.5 seconds normal, ~11 seconds release for).
  - This doesn't change much with new files. Compiling at day 3 (~200 lines) vs day 25 (!1500 lines) is largely unchanged.
- Everything is an object, so using tuples as a key in a hashmap is based on object ID not tuple value
- Would be nice to have in the std lib:
  - PriorityQueue
  - Pairwise operations for tuples: `{1,2,3} + {1,2,3} == {2,4,6}`
- Why default to Int32?
- Using a recursive type: `alias Foo = Int32 | Array(Foo)` in a recursive function produces the type inference equivalent of a stack overflow: `generic type too nested` 

## Not great
- Defining the same method on a class twice [takes the latest definition](https://crystal-lang.org/reference/1.6/syntax_and_semantics/methods_and_instance_variables.html#redefining-methods-and-previous_def)?! Footguns galore.

## Interesting
- [Embedded shell calls](https://crystal-lang.org/reference/1.6/syntax_and_semantics/literals/command.html)?
- Sum type with `Nil` instead a `Maybe` type?
- `unless` and `until` as complements of `if` and `while`
- [External names](https://crystal-lang.org/reference/1.6/syntax_and_semantics/default_values_named_arguments_splats_tuples_and_overloading.html#external-names) to help readability
- Methods are public by default?
  - private methods are accessible by subclasses?
- Compile with `tool hierarchy` to get an object hierarchy tree
  - `crystal tool` looks interesting in general
