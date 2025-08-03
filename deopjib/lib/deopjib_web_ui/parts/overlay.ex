defmodule DeopjibWebUI.Parts.Overlay do
  use DeopjibWeb, :html

  attr(:id, :string, required: true)
  attr(:has_dimm, :boolean, default: true)
  attr(:show, :boolean, default: false)
  attr(:on_close_before, JS, default: %JS{})
  attr(:wrap_class, :any, default: nil)
  attr(:is_close_on_click_away, :boolean, default: true)
  attr(:container_class, :any, default: "z-50")

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
      phx-show={show(@id)}
      phx-hide={@on_close_before |> hide(@id)}
      class={[
        "fixed inset-0 max-h-screen max-w-screen ease-in-out pointer-events-none duration-100 hidden group/overlay",
        @container_class
      ]}
      data-view-state={@view_state}
    >
      <div
        :if={@has_dimm}
        id={"#{@id}-dimm"}
        class="absolute transition-opacity inset-0 size-full blur-dimm backdrop-blur-dimm bg-dimm opacity-0 delay-100 pointer-events-none group-data-[view-state=open]/overlay:opacity-100"
        aria-hidden="true"
      />
      <div class={["absolute inset-0 grid overflow-y-auto pointer-events-none"]}>
        <.focus_wrap
          id={"#{@id}-focus-wrap"}
          class={["pointer-events-none", @wrap_class]}
          phx-key="escape"
          phx-window-keydown={JS.exec("phx-hide", to: "##{@id}")}
          phx-click-away={
            if @is_close_on_click_away, do: JS.exec("phx-hide", to: "##{@id}"), else: nil
          }
        >
          {render_slot(@inner_block)}
        </.focus_wrap>
      </div>
    </div>
    """
  end

  def show(js \\ %JS{}, id) when is_binary(id) do
    js
    |> JS.set_attribute({"data-view-state", "open"}, to: "##{id}")
    |> JS.show(to: "##{id}", transition: {"_", "_", "_"}, time: 100)
    |> JS.add_class("overflow-hidden", to: "body")
    |> JS.focus_first(to: "##{id}")
  end

  def hide(js \\ %JS{}, id) do
    js
    |> JS.set_attribute({"data-view-state", "closed"}, to: "##{id}")
    |> JS.hide(to: "##{id}", transition: {"_", "_", "_"}, time: 100)
    |> JS.remove_class("overflow-hidden", to: "body")
    |> JS.pop_focus()
  end
end
