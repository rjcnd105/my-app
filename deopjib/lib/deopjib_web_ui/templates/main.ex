defmodule DeopjibWebUI.Templates.Main do
  use DeopjibWeb, :html

  attr(:class, :string)
  slot(:inner_block)

  def render(assigns) do
    ~H"""
    <div class={["px-5", @class]}>
      {render_slot(@inner_block)}
    </div>
    """
  end
end
