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

