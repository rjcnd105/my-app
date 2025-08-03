defmodule DeopjibWebUI.Parts.Button do
  use DeopjibWeb, :html

  @selected_class "data-selected:bg-primary data-selected:text-white data-selected:pointer-events-none"

  @theme_classes [
    none: "bg-none",
    primary: "bg-primary text-white disabled:bg-gray100",
    sub: "bg-sub #{@selected_class}",
    gray: "bg-lightgray100 #{@selected_class}",
    warning: "bg-warning text-white disabled:bg-gray100 ",
    dark: "bg-darkgray200 text-white disabled:bg-gray100 #{@selected_class}",
    ghost:
      "border border-blue200 rounded-[26px] text-blue300 disabled:text-gray100 disabled:border-gray100",
    text:
      "text-primary underline underline-offset-3 disabled:text-gray100 group-invalid/form:text-gray100"
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
  attr(:type, :string, default: "button")
  attr(:rest, :global, include: ~w(disabled type form name value))

  slot(:inner_block, required: true)

  def render(assigns) do
    theme_class = Keyword.get(@theme_classes, assigns[:theme])
    size_class = Keyword.get(@size_classes, assigns[:size])

    assigns =
      assigns
      |> assign(
        classes: [
          "disabled:cursor-not-allowed",
          "group-invalid/form:pointer-events-none group-invalid/form:cursor-not-allowed",
          assigns[:_submit_class],
          size_class,
          theme_class,
          assigns[:is_rounded] && "!rounded-[26px]",
          assigns.class
        ]
      )

    ~H"""
    <button data-loading={@is_loading} class={@classes} {@rest}>
      {render_slot(@inner_block)}
    </button>
    """
  end

  def themes, do: @themes
  def sizes, do: @sizes
end
