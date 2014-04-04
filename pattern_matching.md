# Pattern Matching
Pattern matching lives at the heart of the Erlang Virtual Machine. When binding or invoking a function, the VM is pattern matching on the provided expression. For example, when Elixir binds a variable on the left hand side of `=` with the expression on the right, it always does so via pattern matching.

```elixir
iex(1)> a = 1
1
iex(2)> 1 = a
1
iex(3)> b = 2
2
iex(4)> ^a = b
** (MatchError) no match of right hand side value: 2
iex(5)> ^a = 1
1
iex(6)> [first, 2, last] = [1, 2, 3]
[1, 2, 3]
iex(7)> first
1
iex(8)> last
3
```

`^a = b` shows the syntax for pattern matching against a variable's value instead of performing assignment. Pattern matching is used throughout Elixir programs for destructuring assignment, control flow, function invocation, and simple failure modes where a program is expected to crash unless a specific pattern is returned.
