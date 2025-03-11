defmodule DeopjibWebUI.Composites.Toast do
  use DeopjibWeb, :html

  defstruct [:uuid]

  def render(assigns) do
    ~H"""
      <.toast_container />
      <.toast_template />
    """
  end

  attr(:duration, :integer, default: 4000)
  attr(:rest, :global)

  slot(:inner_block)

  attr(:max_count, :integer, default: 3)

  def toast_container(assigns) do
    ~H"""
    <div
      id="toast-container"
      class="fixed bottom-4 left-4 z-50 flex flex-col gap-2"
      phx-update="ignore"
      ui_toast-container

      data-duration={@duration}
      data-max-count={@max_count}
      phx-hook="ToastHook"
    >
       {render_slot(@inner_block)}
    </div>
    """
  end

  attr(:class, :string, default: "")
  attr(:rest, :global)

  def toast_template(assigns) do
    ~H"""
    <template id="toast-template">
      <div
        class={"transition duration-300 contain-paint ease-in-out flex items-center bg-darkgray200 text-blue200 rounded-md w-[334px] h-12 px-4 #{@class}"}
        style="height:0;"
      >
      </div>
    </template>
    """
  end

  def toast(data) do
    JS.dispatch("toast/open", detail: data)
  end
end
