# Control Flow

### Truthiness
Only `false` and `nil` are falsey. All other values are considered truthy.

### if / unless
Elixir sports the traditional `if` and `unless` keywords for control flow branching, but as well see, their use will be limited in favor of superior approaches.

```elixir
iex(1)> saved = true
true
iex(2)> if saved, do: IO.puts("saved"), else: IO.puts("failed")
saved
:ok

iex(3)> if saved do
...(3)>   IO.puts "saved"
...(3)> else
...(3)>   IO.puts "failed"
...(3)> end
saved
:ok

iex(4)> unless saved do
...(4)>   IO.puts "save failed"
...(4)> end
nil
```

The first two `if` examples demonstrate Elixir's inline and expanded expression syntax. In fact, the expanded, multiline example is simply sugar for the the inline `do:` / `else:` syntax.

### cond
For cases where nesting or chaining ifs would be required, `cond` can be used instead to list multiple expressions and evaluate the first truthy match.

```elixir
iex(1)> temperature = 30
30
iex(2)> cond do
...(2)>   temperature >= 212 -> "boiling"
...(2)>   temperature <= 32 -> "freezing"
...(2)>   temperature <= -459.67 -> "absolute zero"
...(2)> end
"freezing"
```

### case
`case` provides control flow based on pattern matching. Given an expression, case will match against each clause until the first pattern is matched. At least one pattern must be matched or `CaseClauseError` will be raised. Let's write a mini calculation parser to perform a few basic operations:

```elixir
iex>
calculate = fn expression ->
  case expression do
    {:+, num1, num2} -> num1 + num2
    {:-, num1, num2} -> num1 - num2
    {:*, num1, 0}    -> 0
    {:*, num1, num2} -> num1 * num2
    {:/, num1, num2} -> num1 / num2
  end
end
#Function<6.17052888 in :erl_eval.expr/5>

iex(2)> calculate.({:+, 8, 2})
10
iex(3)> calculate.({:*, 8, 0})
0
iex(4)> calculate.({:*, 8, 2})
16
iex(5)> calculate.({:^, 8, 2})
** (CaseClauseError) no case clause matching: {:^, 8, 2}
iex(5)>
```

The `calculate` function accepts a three element tuple containing an atom to represent the operation to perform followed by two numbers. `case` is used to pattern match  against the operation, as well as bind the the `num1` and `num2` variables for the matched clause.

An underscore in a match can serve as a "catch-all" clause:


```elixir
iex>

calculate = fn expression ->
  case expression do
    {:+, num1, num2} -> num1 + num2
    {:-, num1, num2} -> num1 - num2
    {:*, num1, num2} -> num1 * num2
    _ -> raise "Unable to parse #{inspect expression}"
  end
end
#Function<6.17052888 in :erl_eval.expr/5>

iex(7)> calculate.({:/, 10, 2})
** (RuntimeError) Unable to parse {:/, 10, 2}
```

We used an anonymous function to wrap the `case` expression for invocation convenience, but we could have accomplished a similar approach using only an anonymous function with multiple clauses:

Pattern Matching - multiple function clauses
```elixir
iex>
calculate = fn
  {:+, num1, num2} -> num1 + num2
  {:-, num1, num2} -> num1 - num2
  {:*, num1, 0} -> 0
  {:*, num1, num2} -> num1 * num2
end
#Function<6.17052888 in :erl_eval.expr/5>

iex(12)> calculate.({:*, 8, 0})
0
iex(13)> calculate.({:*, 2, 2})
4
```

## Guard Clauses
*Guard Clauses* can be used to restrict a pattern from matching based on a condition or set of conditions. Consider an extension to our calculation parser where dividing by zero should never occur:

```elixir
iex>
calculate = fn expression ->
  case expression do
    {:+, num1, num2} -> num1 + num2
    {:-, num1, num2} -> num1 - num2
    {:*, num1, num2} -> num1 * num2
    {:/, num1, num2} when num2 != 0 -> num1 / num2
  end
end
#Function<6.17052888 in :erl_eval.expr/5>

iex(8)> calculate.({:/, 10, 2})
5.0
iex(9)> calculate.({:/, 10, 0})
** (CaseClauseError) no case clause matching: {:/, 10, 0}
```

The Virtual Machine supports a limited set of guard expressions:

- comparison, boolean, and arithmetic operators
  - ==, !=, ===, !==, >, <, <=, >=
  - and, or, not, !
  - +, -, *, /
  - examples
    - `def credit(balance, amt) when amt > 0`
    - `def debit(balance, amt) when amt > 0 and balance >= amt`


- concatentation operators, providing the first term is a literal
  - `<>`, `++`


- the `in` operator
  - examples
    - `def grade(letter) when letter in ["A", "B"]`


- type checking functions:
  - is_atom/1
  - is_binary/1
  - is_bitstring/1
  - is_boolean/1
  - is_exception/1
  - is_float/1
  - is_function/1
  - is_function/2
  - is_integer/1
  - is_list/1
  - is_number/1
  - is_pid/1
  - is_port/1
  - is_record/1
  - is_record/2
  - is_reference/1
  - is_tuple/1


- top-level functions:
  - abs(Number)
  - bit_size(Bitstring)
  - byte_size(Bitstring)
  - div(Number, Number)
  - elem(Tuple, n)
  - float(Term)
  - hd(List)
  - length(List)
  - node()
  - node(Pid|Ref|Port)
  - rem(Number, Number)
  - round(Number)
  - self()
  - size(Tuple|Bitstring)
  - tl(List)
  - trunc(Number)
  - tuple_size(Tuple)
