# Protocols

Protocols provide ad-hoc polymorphism. This pattern allows library consumers
to implement protocols against third party modules.

```elixir
defimpl String.Chars, for: Status do
  def to_string(status = %Status{mentions: []}) do
    "#{status.username}: #{status.text}"
  end
  def to_string(status) do
    """
    #{status.username}': #{status.text}
    mentions: #{inspect status.mentions}
    """
  end
end



iex(2)> status = %Status{username: "chris_mccord", text: "my status"}
%Status{id: nil, text: "my status", username: nil, hash_tags: [],
 mentions: []}

iex(4)> IO.puts status
chrismccord: my status
:ok
iex(5)>
```

### Presence Protocol

```elixir
defprotocol Present do
  def present?(data)
end

defimpl Present, for: [Integer, Float] do
  def present?(_), do: true
end

defimpl Present, for: List do
  def present?([]), do: false
  def present?(_),  do: true
end

defimpl Present, for: Atom do
  def present?(false), do: false
  def present?(nil),   do: false
  def present?(_),     do: true
end

defimpl Present, for: BitString do
  def present?(string), do: String.length(string) > 0
end
```



