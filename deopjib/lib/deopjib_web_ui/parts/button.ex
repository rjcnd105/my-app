defmodule DeopjibWebUI.Parts.Button do
  use DeopjibWeb, :html

  @theme_classes [
    none: "bg-none",
    primary: "bg-primary text-white",
    sub: "bg-sub",
    warning: "bg-warning text-white",
    dark: "bg-darkgray200 text-white",
    ghost: "border border-secondary rounded-[26px] text-secondary",
    text: "text-primary underline underline-offset-3"
  ]

  @size_classes [
    sm: "px-4 h-6 rounded text-caption1 font-light",
    md: "px-4 h-8 rounded-md text-body2",
    lg: "px-4 h-9 rounded-md text-body2",
    xlg: "px-4 h-12 rounded-md text-body2"
  ]

  @themes Keyword.keys(@theme_classes)
  @sizes Keyword.keys(@size_classes)

  attr(:class, :any, default: nil)
  attr(:is_loading, :boolean, default: false)
  attr(:is_rounded, :boolean)
  attr(:theme, :atom, values: @themes)
  attr(:size, :atom, values: @sizes)
  attr(:rest, :global, include: ~w(disabled type form name value))

  slot(:inner_block, required: true)

  def render(assigns) do
    theme_class = Keyword.get(@theme_classes, assigns[:theme])
    size_class = Keyword.get(@size_classes, assigns[:size])

    class = "underline underline-offset-2"

    assigns =
      assigns
      |> assign(
        classes: [
          "disabled:bg-gray100 disabled:cursor-not-allowed",
          size_class,
          theme_class,
          assigns[:is_rounded] && "!rounded-[26px]",
          assigns.class
        ]
      )

    ~H"""
    <button
      data-loading={@is_loading}
      class={@classes}
      {@rest}
    >

      {render_slot(@inner_block)}
    </button>
    """
  end

  def themes, do: @themes
  def sizes, do: @sizes
end
