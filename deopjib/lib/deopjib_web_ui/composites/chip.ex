defmodule DeopjibWebUI.Composites.Chip do
  use DeopjibWeb, :html
  alias DeopjibWebUI.Parts.{Icon}

  @theme_classes [
    white: [
      button: "bg-white font-bold text-primary",
      icon: "fill-gray200 stroke-white"
    ],
    secondary: [
      button: "text-white bg-secondary",
      icon: "fill-primary stroke-white"
    ],
    primary: [
      button: "bg-primary font-bold text-white",
      icon: "fill-blue500 stroke-white"
    ],
    gray: [
      button: "bg-lightgray100 text-black",
      icon: "fill-gray200 stroke-white"
    ]
  ]

  @themes Keyword.keys(@theme_classes)

  attr(:theme, :atom, default: :white, values: @themes)

  slot(:inner_block, required: true)

  def render(%{theme: theme} = assigns) do
    theme = Keyword.get(@theme_classes, theme)

    assigns =
      assigns
      |> assign(
        wrap_class: "flex items-center gap-0.5 pl-2 pr-1 h-9 rounded-[26px] #{theme[:button]}",
        icon_class: "size-4 [&_path]:first:stroke-none #{theme[:icon]}"
      )

    ~H"""
    <div class={@wrap_class} >
      {render_slot(@inner_block)}
      <button class="flex justify-center items-center w-6 h-full">
        <Icon.render
        name={:cross_circle}
        class={@icon_class} />
      </button>
    </div>
    """
  end

  def themes, do: @themes
end
