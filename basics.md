# The Basics

## Types
Elixir is dynamically typed and contains a small, but powerful set of types including:

- Integer
- Float
- Atom
- Tuple
- List
- Bitstring
- Pid

### Atoms
*Atoms* are constants with a name and synonymous with symbols in languages such as Ruby. Atoms are prefixed by a semicolon, such as `:ok` and are a fundamental utility in Elixir. Atoms are used for powerful *pattern matching* techniques, as well as a simple, yet effective way to describe data and return values. Internally, Elixir programs are represented by an AST (Abstract Syntax Tree) comprised of atoms and metadata.


```elixir
iex> is_atom :ok
true
```

### Tuples
*Tuples* are arrays of fixed length, stored contiguously in memory, which can hold any combination of Elixir types. Unlike Erlang, tuples in Elixir are indexed starting at zero.


```elixir
iex(3)> ids = {1, 2, 3}
{1, 2, 3}
iex(4)> is_tuple ids
true
iex(5)> elem ids, 0
1
iex(6)> elem ids, 1
2
```

### Lists
*Lists* are linked-lists containing a variable number of terms. Like tuples, lists can hold any combination of types. Element lookup is `O(N)`, but like most functional languages, composing lists as a head and tail is highly optimized. The `head` of the list is the first element, with the `tail` containing the remaining set. This syntax is denoted by `[h|t]` and can be used to show a list entirely as a series of linked lists. For example:

```elixir
iex(1)> list = [1, 2 ,3]
[1, 2, 3]
iex(2)> [ 1 | [2, 3] ] == list
true
iex(3)> [1 | [2 | [3]] ] == list
true
iex(4)> hd list
1
iex(5)> tl list
[2, 3]
iex(6)> [head|tail] = list
[1, 2, 3]
iex(7)> head
1
iex(8)> tail
[2, 3]
iex(9)> h Enum.at

      def at(collection, n, default // nil)

Finds the element at the given index (zero-based). 
Returns default if index is out of bounds.

Examples

┃ iex> Enum.at([2, 4, 6], 0)
┃ 2
┃ iex> Enum.at([2, 4, 6], 2)
┃ 6
┃ iex> Enum.at([2, 4, 6], 4)
┃ nil
┃ iex> Enum.at([2, 4, 6], 4, :none)
┃ :none

iex(10)> Enum.at list, 2
3
iex(11)> Enum.reverse list
[3, 2, 1]
```

#### *Tip: iex "h" helper function*
> Use `h` followed by a Module name or Module function name to call up markdown formatted documentation as seen in the ninth iex entry of the previous example.


### Keyword Lists
*Keyword Lists* provide syntactic sugar for using a list to represent a series of key-value pairs. Internally, the key-value pairs are simply a list of tuples containing two terms, an atom and value. Keyword lists are convenient for small sets of data where true hash or map based lookup performance is not a concern.

```elixir
iex(2)> types = [atom: "Atom", tuple: "Tuple"]
[atom: "Atom", tuple: "Tuple"]
iex(3)> types[:atom]
"Atom"
iex(4)> types[:not_exists]
nil
iex(5)> types == [{:atom, "Atom"}, {:tuple, "Tuple"}]
true

iex(6)> IO.inspect types
[atom: "Atom", tuple: "Tuple"]

iex(7)> IO.inspect types, raw: true
[{:atom, "Atom"}, {:tuple, "Tuple"}]

iex(9)> Keyword.keys(types)
[:atom, :tuple]
iex(10)> Keyword.values types
["Atom", "Tuple"]

iex(10)> Keyword.
delete/2          delete_first/2    drop/2            equal?/2
fetch!/2          fetch/2           from_enum/1       get/3
get_values/2      has_key?/2        keys/1            keyword?/1
merge/2           merge/3           new/0             new/1
new/2             pop/3             pop_first/3       put/3
put_new/3         split/2           take/2            update!/3
update/4          values/1
```

#### *Tip: tab-complete in `iex`*
> Gratuitous use helps discover new functions and explore module APIs


## Variables & Immutability
Elixir is an immutable programming language. Any variables defined cannot be changed. While this imposes some design considerations, it is a vital part of Elixir's ability to write concurrent and robust applications. Variable assignment is referred to as *binding*, where a term is bound to a value. Here's a taste of some simple bindings:

Binding Variables:
```elixir
iex(1)> sum = 1 + 1
2
iex(2)> names = ["alice", "bob", "ted"]
["alice", "bob", "ted"]
iex(3)> [first | rest ] = names
["alice", "bob", "ted"]
iex(4)> first
"alice"
iex(5)> rest
["bob", "ted"]
```

While variables are immutable and can only be assigned once, Elixir allows us to rebind a variable to a new value. It is important to realize that this does *not* change the original variable. Any reference to the previous assignment maintains the original binding.

Rebinding Variables:
```elixir
iex(1)> sum = 1 + 2
3
iex(2)> initial_sum = fn -> IO.puts sum end
#Function<20.17052888 in :erl_eval.expr/5>

iex(3)> sum = 3 + 4
7
iex(4)> initial_sum.()
3
:ok
```

## Anonymous Functions
Along with variable binding, we just got our first taste of the anonymous function syntax. Anonymous functions can be defined with the `fn arg1, arg2 -> end` syntax and invoked with the explicit "dot notation." As you would expect from a functional language, functions in Elixir are first class citizens and can be passed around and invoked from other functions.

First Class Functions:
```elixir
iex(1)> add = fn num1, num2 ->
...(1)>   num1 + num2
...(1)> end
#Function<12.17052888 in :erl_eval.expr/5>

iex(2)> subtract = fn num1, num2 ->
...(2)>   num1 - num2
...(2)> end
#Function<12.17052888 in :erl_eval.expr/5>

iex(3)> perform_calculation = fn num1, num2, func ->
...(3)>   func.(num1, num2)
...(3)> end
#Function<18.17052888 in :erl_eval.expr/5>

iex(4)> add.(1, 2)
3
iex(5)> perform_calculation.(5, 5, add)
10
iex(6)> perform_calculation.(5, 5, subtract)
0
iex(7)> perform_calculation.(5, 5, &(&1 * &2))
25
```

The last example shows Elixir's *shorthand function* syntax. The `&(&1 * &2)` is simply syntactic sugar for:


```elixir
iex(7)> perform_calculation.(5, 5, fn a, b -> a * b end)
25
```

The shorthand function syntax is useful when performing simple operations on one or two operands:

```elixir
iex(1)> Enum.map [3, 7, 9], &(&1 * 2)
[6, 14, 18]
iex(2)> Enum.filter [1, "red", 2, "green"], &(is_number &1)
[1, 2]
```

#### *Warning: Use sparingly*
> The shorthand syntax is nice and succinct, but it should be used only in cases when its meaning is obvious and your arguments few. Your code should strive for clarity over brevity, always.

## Captured Functions

The shorthand example also showcased the syntax for *capturing* functions. Capturing is used for functions defined within modules, or *named functions* (Covered in the next section), where a function reference is needed instead of invocation. Both name and arity are required for function identification when capturing. 

Capturing named functions:
```elixir
iex(2)> add = &Kernel.+/2
&Kernel.+/2
iex(3)> add.(1,2)
3
iex(2)> Enum.reduce [1, 2, 3], 0, &Kernel.+/2
6
```

When performing `1 + 2`, underneath Elixir is calling the named function `+`, defined and imported automatically from the `Kernel` module. Modules are the main building blocks of Elixir programs.


## Named Functions
Named functions are functions defined within Modules. Named functions are similar to anonymous functions but the dot notation is not required for invocation.

```elixir
iex>

defmodule Weather do
  def celsius_to_fahrenheit(celsius) do
    (celsius * 1.8) + 32
  end

  def high, do: 50
  def low, do: 32
end

{:module, Weather, ...
iex(5)> Weather.high
50
iex(6)> Weather.celsius_to_fahrenheit(20)
68.0
```
We'll be covering modules extensively in the next section.


