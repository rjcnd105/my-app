defmodule DeopjibWeb.Live.ComponentsLive do
  alias DeopjibWebUI.Parts.{Button, Icon, Input}
  alias DeopjibWebUI.Composites.{Chip}
  use DeopjibWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="p-4 bg-gray-100" >
      <.h2>Parts</.h2>
      <.tmpl title="Buttons">
      <%= for size <- Button.sizes(), theme <- Button.themes() do %>
        <Button.render size={size} theme={theme} >{"#{theme} - #{size}"}</Button.render>
      <% end %>
      </.tmpl>

      <.tmpl title="Icons" is_wrap={false}>
      <%= for cls <- ["stroke-primary", "stroke-black stroke-2", "fill-primary stroke-white"] do %>
        <p class="text-subtitle my-2">  {cls}</p>
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

      <.tmpl title="input">
        <Input.render placeholder="Placeholder" />
      </.tmpl>

      <.h2>Composites</.h2>
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

  slot(:inner_block, required: true)

  defp tmpl(assigns) do
    ~H"""
    <div class="mb-8">
      <h3 class="text-title mb-2 font-semibold">{@title}</h3>
      <%= if assigns.is_wrap do %>
      <div class="flex gap-2 flex-wrap">
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
end
