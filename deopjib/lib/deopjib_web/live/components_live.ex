defmodule DeopjibWeb.Live.ComponentsLive do
  alias DeopjibWebUi.Parts.Number
  alias DeopjibWebUi.Parts.Checkbox
  alias DeopjibWebUI.Parts.{Button, Icon}
  alias DeopjibWebUI.Composites.{Chip, InputBox}
  use DeopjibWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="p-4 bg-gray100" >
      <.h2>Parts</.h2>
      <.tmpl title="Buttons">
      <%= for size <- Button.sizes(), theme <- Button.themes() do %>
        <Button.render size={size} theme={theme} >{"#{theme} - #{size}"}</Button.render>
      <% end %>
        <.br/>
        rounded: <Button.render theme={:ghost} size={:lg} is_rounded >rounded</Button.render>
        icon button:
        <Button.render class="p-2">
          <Icon.render name={:trash} class="stroke-black size-5" />
        </Button.render>
      </.tmpl>

      <.tmpl title="Icons" is_wrap={false}>
      <%= for cls <- ["stroke-primary", "stroke-black stroke-2", "fill-primary stroke-white"] do %>
        <p class="text-subtitle my-2"> {cls}</p>
        <.flex>
        <%= for icon <- Icon.icons() do %>
          <%= if cls == "stroke-primary" do %>
          {Atom.to_string(icon) <> ":"}
          <% end %>
          <Icon.render name={icon} class={cls} />
        <% end %>

        </.flex>
      <% end %>
      </.tmpl>
      <.tmpl title="Checkbox" class="bg-white">
        <Checkbox.render  />
        <Checkbox.render checked />

        disabled:
        <Checkbox.render disabled />
        <Checkbox.render checked disabled />
      </.tmpl>
      <.tmpl title="number">
        <Number.render value={99242492}/>
      </.tmpl>


      <.h2>Composites</.h2>
      <.tmpl title="input">
      <%= for theme <- InputBox.themes() do %>
        {theme}:
        <InputBox.render placeholder="Placeholder" theme={theme} />
      <% end %>
        with class:
        <InputBox.render placeholder="Placeholder" class="text-center bg-white" />

        <.br />
        valid:
        <InputBox.render placeholder="Placeholder" theme={:big_rounded_border} class="text-center bg-white" valid="valid" />
        invalid:
        <InputBox.render placeholder="Placeholder" theme={:big_rounded_border} class="text-center bg-white" valid="invalid" />
      </.tmpl>
      <.tmpl title="Chips">
      <%= for theme <- Chip.themes() do %>
        <Chip.render theme={theme} >{"#{theme}"}</Chip.render>
      <% end %>
      </.tmpl>

    </div>
    """
  end

  attr(:title, :string, required: true)
  attr(:is_wrap, :boolean, default: true)
  attr(:class, :string, default: "")

  slot(:inner_block, required: true)

  defp tmpl(assigns) do
    ~H"""
    <div class={"mb-8 #{@class}"}>
      <h3 class="text-title mb-2 font-semibold">{@title}</h3>
      <%= if assigns.is_wrap do %>
      <div class="flex gap-2 flex-wrap w-full">
        {render_slot(@inner_block)}
      </div>
       <% else %>
       {render_slot(@inner_block)}
       <% end %>
    </div>
    """
  end

  slot(:inner_block, required: true)

  defp h2(assigns) do
    ~H"""
    <h2 class="text-heading mb-4">
    {render_slot(@inner_block)}
    </h2>
    """
  end

  slot(:inner_block, required: true)

  defp flex(assigns) do
    ~H"""
    <div class="flex gap-2 flex-wrap">
    {render_slot(@inner_block)}
    </div>
    """
  end

  defp br(assigns) do
    ~H"""
    <div style="width: 100%;" />
    """
  end
end
