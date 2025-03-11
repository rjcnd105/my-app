defmodule DeopjibWebUI.Parts.Number do
  use DeopjibWeb, :html
  alias Deopjib.Cldr.Number

  attr(:value, :integer, required: true)
  attr(:class, :string, default: "")
  attr(:rest, :global)

  def render(assigns) do
    ~H"""
    <span class={"underline underline-offset-3 #{@class}"}>{Number.to_string!(@value)}</span>
    """
  end

  def to_string!(value) do
    Number.to_string!(value)
  end
end
