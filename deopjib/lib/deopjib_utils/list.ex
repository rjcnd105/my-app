defmodule DeopjibUtils.List do
  @spec first_or_nil(list()) :: any | nil
  def first_or_nil([]), do: nil
  def first_or_nil([first | _]), do: first
end
