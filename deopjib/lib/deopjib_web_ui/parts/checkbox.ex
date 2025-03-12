defmodule DeopjibWebUI.Parts.Checkbox do
  use DeopjibWeb, :html
  alias DeopjibWebUI.Parts.Icon

  attr(:name, :any, default: nil)
  attr(:value, :string)
  attr(:checked, :boolean, default: false)
  attr(:class, :string, default: nil)
  attr(:rest, :global)
  attr(:disabled, :boolean, default: false)

  def render(assigns) do
    assigns =
      assign_new(assigns, :checked, fn ->
        Phoenix.HTML.Form.normalize_value("checkbox", assigns.value)
      end)

    ~H"""
    <label class="relative size-6 rounded-full">
      <input
        class="peer size-full focus-visible:ring-1 opacity-0 border-none rounded-full"
        type="checkbox"
        name={@name}
        checked={@checked}
        {@rest}
      />
      <Icon.render
        name={:check_circle_filled}
        class="absolute inset-0 rounded-full fill-gray100 stroke-0 peer-checked:stroke-1 disabled:opacity-50 peer-focus-visible:ring-1 ring-primary peer-checked:fill-primary peer-checked:stroke-white"
      />
    </label>
    """
  end
end
