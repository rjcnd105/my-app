defmodule DeopjibWebUI.Parts.InputBox do
  use DeopjibWeb, :html
  alias DeopjibWebUI.Parts.Icon
  alias DeopjibWebUI.Parts.Button

  @theme_classes [
    none: "h-7 border-none",
    underline: "h-7 border-b-1 border-gray200",
    big_rounded_border: "h-12 px-4 rounded-md border-1 border-gray200"
  ]

  @themes Keyword.keys(@theme_classes)

  @valid_states [nil, "valid", "invalid"]

  attr(:id, :string, required: true)
  attr(:name, :string)
  attr(:theme, :atom, values: @themes, default: :none)
  attr(:class, :string, default: "")
  attr(:has_close, :boolean, default: true)
  attr(:valid, :string || nil, values: @valid_states, default: hd(@valid_states))
  attr(:rest, :global)

  slot(:input_right)
  slot(:bottom)

  def render(assigns) do
    assigns =
      assigns
      |> assign(:theme_class, @theme_classes[assigns.theme])

    ~H"""
    <div class={"#{@theme_class} group/input-box width-full data-[valid=valid]:border-primary data-[valid=invalid]:border-red #{@class}"} data-valid={@valid}>
      <div class="h-full flex items-center justify-center">
        <input class="peer flex flex-1 h-full bg-none p-0 placeholder:text-body2 placeholder:text-gray200 ring-0 border-none" {@rest} phx-hook="EnterSubmit" />
        <Button.render :if={@has_close} phx-click={JS.dispatch("input_box/clear-input")} class="flex justify-center items-center size-8 shrink-0 peer-[&:placeholder-shown]:invisible [&_svg]:fill-gray100 [&_svg]:stroke-white focus-visible:[&_svg]:fill-darkgray100">
          <Icon.render name={:cross_circle} class="fill-gray100 stroke-white size-3.5" />
        </Button.render>
        {render_slot(@input_right)}
      </div>
      {render_slot(@bottom)}
    </div>
    """
  end

  attr(:min_length, :integer, default: nil)
  attr(:max_length, :integer, default: nil)
  attr(:message, :string, default: "")
  attr(:rest, :global)

  def message(assigns) do
    ~H"""
    <div
      class="flex text-caption2 text-gray300 has-data-[ui=input_box#length]:bg-blue300"
      data-ui="input_box#message"
      {@rest}
    >
      <p class="group-data-[valid=invalid]/input-box:text-warning">
        {@message}
      </p>

      <%= if is_integer(@min_length) && is_integer(@max_length) do %>
        <span class="group-data-[valid=invalid]/input-box:text-warning" data-ui="input_box#current_length" />
        &nbsp;/{@max_length}
      <% end %>
    </div>
    """
  end

  def themes, do: @themes
end
