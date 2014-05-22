# Macros

Macros give programmers the power to write code that writes code. This power eliminates boilerplate, allows Domain Specific Language abstractions, and provides the freedom to extend the language. Much of Elixir itself is implemented as macros. Internally, `if` is just a macro that accepts two arguments. The first argument is a condition followed by a keyword list of options containing `do:`, and optionally, `else:`. You can see this in action by defining your own `unless` macro, named `lest`. Macros must be defined within a module, so we'll create our first module, named `Condition`.

```elixir
defmodule Condition do
  defmacro lest(expression, do: block) do
    quote do
      if !unquote(expression), do: unquote(block)
    end
  end
end

{:module, Condition,...
iex(12)> require Condition
nil

iex(13)> Condition.lest 2 == 5, do: "not equal"
"not equal"
:ok

iex(14)> Condition.lest 5 == 5, do: "not equal"
nil
```

The `lest` macro accepts an expression as the first argument, followed by the keyword list of options. It is important to realize that when `2 == 5` was passed to `lest`, the macro received the *representation* of `2 == 5`, not the result. This allows the macro to manipulate and augment the representation of the code before it is compiled and evaluated. `unquote` is used to evaluate the arguments passed in before returning the augmented representation back to the call point. You can use `quote` in `iex` to see the internal representation of any expression:

```elixir
iex(1)> quote do: 2 == 5
{:==, [context: Elixir, import: Kernel], [2, 5]}

iex(2)> quote do: (5 * 2) + 7
{:+, [context: Elixir, import: Kernel],
 [{:*, [context: Elixir, import: Kernel], [5, 2]}, 7]}

iex(3)> quote do: total = 88.00
{:=, [], [{:total, [], Elixir}, 88.0]}
```

As you can see, Elixir code is represented by a hierarchy of three element tuples, containing an atom, metadata, and arguments. Having access to this simple structure in Elixir's own data-types allows for introspection and code generation techniques that are easy to write and a joy to consume.


## Examples
[Phoenix Web Framework](https://github.com/phoenixframework/phoenix) - Router
```elixir
defmodule MyApp.Router do
  use Phoenix.Router

  plug Plug.Static, at: "/static", from: :your_app

  get "/pages/:page", Controllers.Pages, :show, as: :page
  get "/files/*path", Controllers.Files, :show

  resources "users", Controllers.Users do
    resources "comments", Controllers.Comments
  end

  scope path: "admin", alias: Controllers.Admin, helper: "admin" do
    resources "users", Users
  end
end
```

ExUnit Test Framework
```elixir
defmodule Phoenix.Router.RoutingTest do
  use ExUnit.Case

  test "limit resource by passing :except option" do
    conn = simulate_request(Router, :delete, "posts/2")
    assert conn.status == 404
    conn = simulate_request(Router, :get, "posts/new")
    assert conn.status == 200
  end

  test "named route builds _path url helper" do
    assert Router.user_path(id: 88) == "/users/88"
  end
end
```
