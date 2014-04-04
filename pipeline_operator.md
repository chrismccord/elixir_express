## Pipeline Operator
One of the most simple, yet effective features in Elixir is the *pipeline operator*. The pipeline operator solves the issue many functional languages face when composing a series of transformations where the output from one function needs passed as the input to another. This requires solutions to be read in reverse to understand the actions being performed, hampering readability and obscuring the true intent of the code. Elixir elegantly solves this problem by allowing the output of a function to be *piped* as the first parameter to the input of another. At compile time, the functional hierarchy is transformed into the nested, "backward" variant that would otherwise be required.

```elixir
iex(1)> "Hello" |> IO.puts
Hello
:ok
iex(2)> [3, 6, 9] |> Enum.map(fn x -> x * 2 end) |> Enum.at(2)
18
```

To grasp the full utility the pipeline provides, consider a module that fetches new messages from an API and saves the results to a database. The sequence of steps would be:

- Find the account by authorized user token
- Fetch new messages from API with authorized account
- Convert JSON response to keyword list of messages
- Save all new messages to the database

Without Pipeline:
```elixir
defmodule MessageService do
  ...
  def import_new_messages(user_token) do
    Enum.each(
      parse_json_to_message_list(
        fetch(find_user_by_token(user_token), "/messages/unread")
    ), &save_message(&1))
  end
  ...
end
```

Proper naming and indentation help the readability of the previous block, but its intent is not immediately obvious without first taking a moment to decompose the steps from the inside out to grasp an understanding of the data flow.

Now consider this series of steps with the pipeline operator:

With Pipeline
```elixir
defmodule MessageService do
  ...
  def import_new_messages(user_token) do
    user_token
    |> find_user_by_token
    |> fetch("/messages/unread")
    |> parse_json_to_message_list
    |> Enum.each(&save_message(&1))
  end
	...
end
```

Piping the result of each step as the first argument to the next allows allows programs to be written as a series of transformations that any reader would immediately be able to read and comprehend without expending extra effort to unwrap the functions, as in the first solution. 

The Elixir standard library focuses on placing the subject of the function as the first argument, aiding and encouraging the natural use of pipelines.
