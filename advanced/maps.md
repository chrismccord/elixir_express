# Maps & Structs

Maps are key/value stores and synomous with hashes or dictionaries in other languages. Maps support powerful pattern matching and upsert operations and are defined with the `%{}` syntax.

```elixir
iex(4)> map = %{name: "elixir", age: 3, parent: "erlang"}
%{age: 3, name: "elixir", parent: "erlang"}

iex(5)> map[:name]
"elixir"

iex(6)> %{name: name} = map
%{age: 3, name: "elixir", parent: "erlang"}

iex(8)> %{age: age} = map
%{age: 3, name: "elixir", parent: "erlang"}
iex(9)> age
3

iex(10)> map = %{map | age: 4}
%{age: 4, name: "elixir", parent: "erlang"}

iex(11)> map = %{map | age: 4, new_key: "new val"}
** (ArgumentError) argument error
    (stdlib) :maps.update(:new_key, "new val", %{age: 4, name: "elixir", parent: "erlang"})
```

Structs are tagged maps used for polymorphic dispatch, pattern matching, and replace the now deprecated Records.

```elixir
iex(1)>
defmodule Status do
  defstruct id: nil, text: "", username: nil, hash_tags: [], mentions: []
end

iex(2)> status = %Status{text: "All Aboard!"}
%Status{id: nil, text: "All Aboard!", username: nil, hash_tags: [],
 mentions: []}
 
iex(3)> status.text
"All Aboard!"

iex(4)> status = %Status{status | text: "RT All Aboard!"}
%Status{id: nil, text: "RT All Aboard!", username: nil, hash_tags: [],
 mentions: []}
iex(5)> status.text
"RT All Aboard!"

iex(6)> %Status{status | text: "@elixir-lang rocks!", username: "chris_mccord"}
Status{id: nil, text: "@elixir-lang rocks!", username: "chris_mccord",
 hash_tags: [], mentions: []}
 ```
