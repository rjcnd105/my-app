defmodule DeopjibWebUI.Composites.InputBox do
  alias DeopjibWebUI.Parts.Icon
  alias DeopjibWebUI.Parts.Button
  use DeopjibWeb, :html

  @theme_classes [
    none: "h-7 border-none",
    underline: "h-7 border-b-1 border-gray200",
    big_rounded_border: "h-12 px-4 rounded-md border-1 border-gray200"
  ]

  @themes Keyword.keys(@theme_classes)

  @valid_states [nil, "valid", "invalid"]

  attr(:rest, :global)
  attr(:theme, :atom, values: @themes, default: :none)
  attr(:class, :string, default: "")
  attr(:has_close, :boolean, default: true)
  attr(:valid, :string || nil, values: @valid_states, default: hd(@valid_states))

  slot(:input_right)
  slot(:bottom)

  def render(assigns) do
    assigns =
      assigns
      |> assign(:theme_class, @theme_classes[assigns.theme])

    ~H"""
    <div class={"#{@theme_class} group data-[valid=valid]:border-primary data-[valid=invalid]:border-red #{@class}"} data-valid={@valid}>
      <div class="h-full flex items-center justify-center">
        <input class="peer h-full bg-none p-0 placeholder:text-body2 placeholder:text-gray200 ring-0 border-none" {@rest} />
        <Button.render :if={@has_close} phx-click={JS.dispatch("input_box/clear-input")} class="flex justify-center items-center size-8  peer-[&:placeholder-shown]:invisible [&_svg]:fill-gray100 [&_svg]:stroke-white focus-visible:[&_svg]:fill-darkgray100">
          <Icon.render name={:cross_circle} class="fill-gray100 stroke-white size-3.5" />
        </Button.render>
        {render_slot(@input_right)}
      </div>
      {render_slot(@bottom)}
    </div>
    """
  end

  def themes, do: @themes
end
