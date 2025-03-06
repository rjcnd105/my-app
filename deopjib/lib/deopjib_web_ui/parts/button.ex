defmodule DeopjibWebUI.Parts.Button do
  use DeopjibWeb, :html

  @theme_classes [
    primary: "bg-primary text-white",
    sub: "bg-sub",
    warning: "bg-warning text-white",
    text: "bg-none",
    ghost: "border border-secondary rounded-[26px] text-secondary",
    ghost_primary: "bg-primary border rounded-[26px] border-blue-200 text-blue-200 "
  ]

  @size_classes [
    sm: "h-6 text-caption1 font-light rounded",
    md: "h-8 text-body2 rounded-md",
    lg: "h-12 font-bold rounded-md"
  ]

  @themes Keyword.keys(@theme_classes)
  @sizes Keyword.keys(@size_classes)

  # 특별한 크기 적용이 필요하지 않은 테마들
  @size_excluded_themes [:ghost, :ghost_primary]

  attr(:class, :any, default: nil)
  attr(:is_loading, :boolean, default: false)
  attr(:theme, :atom, default: :text, values: @themes)
  attr(:size, :atom, default: :md, values: @sizes)
  attr(:rest, :global, include: ~w(disabled type form name value))

  slot(:inner_block, required: true)

  def render(%{size: size, theme: theme} = assigns) do
    size_class = Keyword.get(@size_classes, size)
    theme_class = Keyword.get(@theme_classes, theme)

    assigns =
      assigns
      |> assign(
        classes: [
          "px-4 disabled:bg-gray-100 disabled:cursor-not-allowed",
          theme not in @size_excluded_themes && size_class,
          theme_class,
          assigns.class
        ]
      )

    ~H"""
    <button
      data-is_loading={@is_loading}
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
