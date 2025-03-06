defmodule DeopjibWebUI.Parts.Input do
  use DeopjibWeb, :html

  attr(:rest, :global, include: ~w(disabled id name type value placeholder))

  def render(assigns) do
    ~H"""
    <input class="placeholder:text-body2 placeholder:text-gray-200" {@rest} />
    """
  end
end
