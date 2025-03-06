defmodule DeopjibWebUi.Composites.InputField do
  use DeopjibWeb, :html

  def render(assigns) do
    ~H"""
    <div>
      <label for={@id}><%= @label %></label>
      <input type="text" id={@id} name={@name} value={@value} />
    </div>
    """
  end
end
