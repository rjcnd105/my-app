defmodule DeopjibUtils.Map do
  @doc """
  Retrieves a value from a nested map using a list of keys.

  Returns the value if found, or `nil` if any key is missing or the map is `nil`.

  Examples:
    iex> DeopjibUtils.Map.get_nested(%{a: %{b: %{c: 1}}}, [:a, :b, :c])
    1
    iex> DeopjibUtils.Map.get_nested(%{a: %{b: %{c: 1}}}, [:a, :b, :d])
    nil
    iex> DeopjibUtils.Map.get_nested(nil, [:a, :b, :c])
    nil
  """
  def get_nested(map, [k | rest]), do: Map.get(map, k) |> get_nested(rest)
  def get_nested(map, []), do: map
  def get_nested(nil, _), do: nil
end
