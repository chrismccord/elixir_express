# Modules

Modules are the main building blocks of Elixir programs. Modules  can contain named functions, import functions from other modules, and use macros for powerful composition techniques.

## Liftoff! Your First Program
Open up your favorite editor and create your first Elixir program:

```elixir
defmodule Rocket do

  def start_launch_sequence do
    IO.puts "Liftoff in 10..."
    countdown(10)
  end

  defp countdown(0), do: blastoff
  defp countdown(seconds) do
    IO.puts seconds
    countdown(seconds - 1)
  end

  def blastoff do
    IO.puts "Liftoff!"
  end
end

Rocket.start_launch_sequence
```

We can compile and run our program in a single step using the `elixir` command:

```bash
$ elixir rocket1.exs
Liftoff in 10...
10
9
8
7
6
5
4
3
2
1
Liftoff!
```

### *Tip: Elixir files
> Elixir files are named `.exs`, which stands for Elixir script, and `.ex`
> are typically compiled to Erlang BEAM byte-code. For simple one off programs, sys-admin scripts etc. use `.exs`.

You can also fire up iex in the same directory and use the `c` helper function

```elixir
iex(1)> c "rocket1.exs"
Liftoff in 10...
...
```

Publicly reachable functions are defined with the `def` keyword, while private functions use `defp`. It is common with Elixir code to group public functions with their private counterparts instead of lumping all public and private functions as separate groups in the source file. Attempting to call a `defp` function will result in an error:

```elixir
iex(13)> Rocket.countdown(1)
** (UndefinedFunctionError) undefined function: Rocket.countdown/1
    Rocket.countdown(1)
```

## Function Pattern Matching

The `countdown` function gives the first glimpse of function pattern matching. Pattern matching allows multiple function clauses to be defined with the same name. The BEAM Virtual Machine will match against each definition by the order defined until the arguments match the defined pattern. `countdown(0)` serves as the termination of the recursive calls and has higher precedence over `countdown(seconds)` because it is defined first. Had `countdown(0)` been defined second, the program would never terminate because the first clause would always match. Pattern matching often removes the need for complex if-else branches and helps keep module functions short and clear.


Let's up the sophistication of our Rocket module to allow the caller to specify a countdown when starting the launch:

```elixir
defmodule Rocket do

  def start_launch_sequence(seconds \\ 10) do
    IO.puts "Liftoff in #{seconds}..."
    countdown(seconds)
  end

  defp countdown(0), do: blastoff
  defp countdown(seconds) do
    IO.puts seconds
    countdown(seconds - 1)
  end

  defp blastoff do
    IO.puts "Liftoff!"
  end
end
```

Instead of compiling and invoking the program with `elixir`, we can use `iex` to compile, load, and experiment with our source files via the `c` helper function.

```elixir
iex(1)> c "rocket2.ex"
[Rocket]
iex(2)> Rocket.start_launch_sequence(5)
Liftoff in 5...
5
4
3
2
1
Liftoff!
:ok
```

Line 3 accepts an argument, with a default value of 10 denoted by the `\\` syntax. We can leave our `iex` session running and recompile and reload our program after each change by re-executing the `c` function.


## Guard Clauses
There is a problem with the countdown implementation. If a caller passes a negative number, the recursive calls will never terminate. It could be tempting to simply wrap the function in an if clause or manually raising an error, but Elixir provides a better solution with *guard clauses*.

```elixir
defmodule Rocket do

  def start_launch_sequence(seconds // 10) when seconds >= 0 do
    IO.puts "Liftoff in #{seconds}..."
    countdown(seconds)
  end

  defp countdown(0), do: blastoff
  defp countdown(seconds) do
    IO.puts seconds
    countdown(seconds - 1)
  end

  defp blastoff do
    IO.puts "Liftoff!"
  end
end
```

Now attempting to invoke the countdown with a negative number raises a `FunctionClauseError` because the guard serves as a unique component of the function signature.

```elixir
iex(2)> c "rocket3.ex"
rocket3.ex:1: redefining module Rocket
[Rocket]
iex(3)> Rocket.start_launch_sequence(-1)
** (FunctionClauseError) no function clause matching in Rocket.start_launch_sequence/1
    rocket3.ex:3: Rocket.start_launch_sequence(-1)
```

### Anonymous Function Guards

In addition to named functions, guard clauses can also be used on anonymous functions and `case` expressions.

```elixir
process_input = fn
  {:left, spaces}  -> IO.puts "player moved left #{spaces} space(s)"
  {:right, spaces} -> IO.puts "player moved right #{spaces} space(s)"
  {:up, spaces}    -> IO.puts "player moved up #{spaces} space(s)"
  {:down, spaces}  -> IO.puts "player moved down #{spaces} space(s)"
end
Function<6.17052888 in :erl_eval.expr/5>

iex(3)> process_input.({:left, 5})
player moved left 5 space(s)
:ok

iex(4)> process_input.({:up, 2})
player moved up 2 space(s)
:ok

iex(5)> process_input.({:jump, 2})
** (FunctionClauseError) no function clause matching in :erl_eval."-inside-an-interpreted-fun-"/1
```

## Alias, Import, Require
A few keywords exist in Elixir that live at the heart of module composition:

* `alias` used to register aliases for modules
* `import` imports functions and macros from other modules
* `require` ensures modules are compiled and loaded so that macros can be invoked

In the example below `:math` refers to the Erlang math module and makes
it accessible as `Math` (following the Elixir naming convention for
Modules).

Furthermore, we could have imported the entire Math module with `import
Math`; however, since we only wish to call the `pi` function, we've limited the
import to only that specific function.

```elixir
defmodule Converter do
  alias :math, as: Math
  import Math, only: [pi: 0]

  def degrees_to_radians(degrees) do
    degrees * (pi / 180)
  end

  def sin_to_cos(x) do
    Math.cos(x - (pi/2))
  end
end
{:module, Converter...

iex(13)> Converter.degrees_to_radians(90)
1.5707963267948966

iex(14)> Converter.sin_to_cos(120)
0.5806111842123187
```

Rather than calling `cos` via the Math module, we could have imported it
as well

```elixir
  import Math, only: [pi: 0, cos: 1]

  def sin_to_cos(x) do
    cos(x - (pi/2))
  end
```
