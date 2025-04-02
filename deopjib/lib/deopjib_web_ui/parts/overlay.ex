defmodule DeopjibWebUI.Parts.Overlay do
  use DeopjibWeb, :html

  attr(:id, :string, required: true)
  attr(:has_dimm, :boolean, default: true)
  attr(:show, :boolean, default: false)
  attr(:on_cancel, JS, default: %JS{})
  attr(:wrap_class, :any, default: nil)
  attr(:hide_delay, :integer, default: 100)
  attr(:show_delay, :integer, default: 100)
  slot(:inner_block)

  def full(assigns) do
    assigns =
      assigns
      |> assign_new(:view_state, fn ->
        if assigns.show, do: "open", else: "closed"
      end)

    ~H"""
    <div
      id={@id}
      phx-mounted={@show && JS.exec("phx-show", to: "##{@id}")}
      phx-show={show(@id, @show_delay)}
      phx-hide={@on_cancel |> hide(@id, @hide_delay)}
      class="fixed inset-0 max-h-screen max-w-screen backdrop-blur-dimm z-50 ease-in-out duration-100 hidden group/overlay"
      data-view-state={@view_state}
    >
      <div
        :if={@has_dimm}
        id={"#{@id}-dimm"}
        class="absolute transition-opacity inset-0 size-full blur-dimm bg-dimm opacity-0 group-data-[view-state=open]/overlay:opacity-100"
        aria-hidden="true"
      />
      <div class={["absolute inset-0 grid overflow-y-auto"]}>
        <.focus_wrap
          id={"#{@id}-focus-wrap"}
          class={["pointer-events-none", @wrap_class]}
          phx-key="escape"
          phx-window-keydown={JS.exec("phx-hide", to: "##{@id}")}
          phx-click-away={JS.exec("phx-hide", to: "##{@id}")}
        >
        {render_slot(@inner_block)}
        </.focus_wrap>
      </div>
    </div>
    """
  end

  def show(js \\ %JS{}, id, show_delay) when is_binary(id) do
    js
    |> JS.set_attribute({"data-view-state", "open"}, to: "##{id}")
    |> JS.show(to: "##{id}", transition: {"_", "_", "_"}, time: show_delay)
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: "##{id}")
  end

  def hide(js \\ %JS{}, id, hide_delay) do
    js
    |> JS.set_attribute({"data-view-state", "closed"}, to: "##{id}")
    |> JS.hide(to: "##{id}", transition: {"_", "_", "_"}, time: hide_delay)
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end
end
