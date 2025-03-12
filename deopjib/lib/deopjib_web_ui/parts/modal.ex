defmodule DeopjibWebUI.Parts.Modal do
  use DeopjibWeb, :html
  alias DeopjibWebUI.Parts.Overlay

  @moduledoc """
  Implement of Dialog components from https://ui.shadcn.com/docs/components/dialog
  """

  attr(:id, :string, required: true)
  attr(:has_dimm, :boolean, default: true)
  attr(:show, :boolean, default: false)
  attr(:on_cancel, JS, default: %JS{})
  attr(:class, :string, default: nil)

  slot(:inner_block)
  slot(:content_wrapper)

  def modal(assigns) do
    ~H"""
    <Overlay.full
      id={@id}
      show={@show}
      has_dimm={@has_dimm}
      on_cancel={@on_cancel}
    >
      <%= if @content_wrapper != [] do %>
        {render_slot(@content_wrapper)}
      <% else %>
        <.content_wrapper>
          {render_slot(@inner_block)}
        </.content_wrapper>
      <% end %>
    </Overlay.full>
    """
  end

  attr(:class, :string, default: nil)
  attr(:rest, :global)
  slot(:inner_block, required: true)

  def content_wrapper(assigns) do
    ~H"""
    <div
      role="dialog"
      aria-modal="true"
      tabindex="0"
      class={["max-h-[calc(100dvh - 2rem)] bg-white p-6 overflow-y-auto overflow-x-hidden sm:max-w-[336px] rounded-lg focus-visible:outline-1 group-data-[view-state=open]/overlay:animate-modal-in group-data-[view-state=closed]/overlay:animate-modal-out", @class]}
      {@rest}
    >

      {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :string, default: nil)
  slot(:inner_block, required: true)
  attr(:rest, :global)

  def title(assigns) do
    ~H"""
    <h3 class={["text-subtitle font-bold text-center mb-2", @class]} {@rest}>
      {render_slot(@inner_block)}
    </h3>
    """
  end

  defdelegate show(id), to: Overlay
  defdelegate show(js, id), to: Overlay
  defdelegate hide(id), to: Overlay
  defdelegate hide(js, id), to: Overlay
end
