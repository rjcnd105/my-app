defmodule DeopjibWebUI.Parts.Button do
  use DeopjibWeb, :html

  @sizes [
    sm: "h-6 text-caption1 font-light rounded",
    md: "h-8 text-body2 rounded-md",
    lg: "h-12 font-bold rounded-md"
  ]

  @themes [
    primary: "bg-primary text-white",
    sub: "bg-sub",
    warning: "bg-warning text-white",
    text: "bg-none",
    ghost: "border border-secondary rounded-[26px] text-secondary",
    ghost_primary: "bg-primary border rounded-[26px] border-blue-200 text-blue-200 "
  ]

  # 특별한 크기 적용이 필요하지 않은 테마들
  @size_excluded_themes [:ghost, :ghost_primary]

  attr(:class, :any, default: nil)
  attr(:is_loading, :boolean, default: false)
  attr(:theme, :atom, default: :text, values: Keyword.keys(@themes))
  attr(:size, :atom, default: :md, values: Keyword.keys(@sizes))
  attr(:rest, :global, include: ~w(disabled type form name value))

  slot(:inner_block, required: true)

  def render(assigns) do
    size_class = Keyword.get(@sizes, assigns.size)
    theme_class = Keyword.get(@themes, assigns.theme)

    classes = [
      "px-4 disabled:bg-gray-100 disabled:cursor-not-allowed",
      !Enum.member?(@size_excluded_themes, assigns.theme) && size_class,
      theme_class,
      assigns.class
    ]

    ~H"""
    <button
      data-is_loading={@is_loading}
      class={classes}
      {@rest}
    >

      {render_slot(@inner_block)}
    </button>
    """
  end

  def sizes, do: Keyword.keys(@sizes)
  def themes, do: Keyword.keys(@themes)
end
