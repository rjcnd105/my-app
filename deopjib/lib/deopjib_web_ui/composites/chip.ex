defmodule DeopjibWebUI.Composites.Chip do
  alias DeopjibWebUI.Parts.{Icon}
  use DeopjibWeb, :html

  @themes [
    white: [
      button: "bg-white font-bold text-primary",
      icon: "fill-gray-200 stroke-white"
    ],
    secondary: [
      button: "text-white bg-secondary",
      icon: "fill-primary stroke-white"
    ],
    primary: [
      button: "bg-primary font-bold text-white",
      icon: "fill-blue-500 stroke-white"
    ],
    gray: [
      button: "bg-lightgray-100 text-black",
      icon: "fill-gray-200 stroke-white"
    ]
  ]

  attr(:theme, :atom, default: :white, values: Keyword.keys(@themes))

  slot(:inner_block, required: true)

  def render(assigns) do
    theme = Keyword.get(@themes, assigns.theme)

    wrap_class =
      "flex items-center gap-0.5 pl-2 pr-1 h-9 rounded-[26px] #{theme[:button]}"

    icon_class = "size-4 [&_path]:first:stroke-none #{theme[:icon]}"

    ~H"""
    <div class={wrap_class}>
      {render_slot(@inner_block)}
      <button class="flex justify-center items-center w-6 h-full">
        <Icon.render
        name={:cross_circle}
        class={icon_class} />
      </button>
    </div>
    """
  end

  def themes, do: Keyword.keys(@themes)
end
