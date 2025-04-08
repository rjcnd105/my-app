defmodule DeopjibWebUI.Parts.InputBox do
  use DeopjibWeb, :html
  alias DeopjibWebUI.Parts.Icon
  alias DeopjibWebUI.Parts.Button

  # 추후 Input 컴포넌트 따로 분리

  @theme_classes none: "h-7 border-none",
                 underline: "h-7 border-b-1 border-gray200",
                 big_rounded_border: "h-12 px-4 rounded-md border-1 border-gray200"

  @themes Keyword.keys(@theme_classes)

  attr(:theme, :atom, values: @themes, default: :none)
  attr(:has_close, :boolean, default: true)
  attr(:has_message, :boolean, default: true)
  attr(:valid, :any, default: nil)
  attr(:field, Phoenix.HTML.FormField)
  attr(:box_class, :any, default: nil)
  attr(:id, :any)
  attr(:name, :any)
  attr(:value, :any)
  attr(:errors, :list, default: [])
  attr(:message, :string, default: nil)
  attr(:min_length, :integer, default: nil)
  attr(:max_length, :integer, default: nil)
  attr(:class, :any, default: nil)
  attr(:error_message, :any, default: nil)
  attr(:container_class, :any, default: nil)
  attr(:"phx-mounted", JS, default: %JS{})
  attr(:rest, :global, include: ~w(placeholder))

  slot(:input_right)

  slot(:message_line)

  def render(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, id: assigns[:id] || field.id)
    |> assign_new(:name, fn -> field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> assign(
      :error_message,
      field.errors
      |> DeopjibWeb.Utils.Error.translate_first_error()
    )
    |> render()
  end

  def render(assigns) do
    assigns =
      assigns
      |> assign_new(:value, fn -> nil end)
      |> assign(:theme_class, @theme_classes[assigns.theme])

    ~H"""
    <div
      class={["group/input-box h-fit", @container_class]}
      data-ui="input_box"
      data-valid={getValid(@valid)}
    >
      <div
        class={["width-full group-data-[valid=valid]/input-box:border-primary group-data-[valid=invalid]/input-box:border-red", @theme_class,  @box_class]}
      >
        <div class="h-full flex items-center justify-center">
          <input
            type="text"
            id={@id}
            name={@name}
            value={Phoenix.HTML.Form.normalize_value("text", @value)}
            class={["peer flex flex-1 h-full bg-none p-0 placeholder:text-body2 placeholder:text-gray200 ring-0 border-none", @class]}
            phx-mounted={assigns[:"phx-mounted"] |> JS.dispatch("addEvent:enterSubmit", detail: %{event_name: "keyup"}) }
            {@rest}

          />
          <Button.render
            :if={@has_close}
            type="button"
            phx-click={JS.dispatch("input_box/clear-input")}
            class="flex justify-center items-center size-8 shrink-0 peer-[&:placeholder-shown]:invisible [&_svg]:fill-gray100 [&_svg]:stroke-white focus-visible:[&_svg]:fill-darkgray100"
          >
            <Icon.render name={:cross_circle} class="fill-gray100 stroke-white size-3.5" />
          </Button.render>
          {render_slot(@input_right)}
        </div>
      </div>
      <%= if @message_line do %>
        {render_slot(@message_line, @error_message)}
      <% else %>
        <.messages message={@message} max_length={@max_length} min_length={@min_length} error_message={@error_message} />
      <% end %>
    </div>

    """
  end

  attr(:error_message, :any, default: nil)
  attr(:min_length, :integer, default: nil)
  attr(:max_length, :integer, default: nil)
  attr(:hook, :string, default: "InputBoxLengthHook")
  attr(:message, :string, default: nil)

  def messages(assigns) do
    ~H"""
      <div
        :if={is_binary(@message) || is_binary(@error_message) || is_integer(@max_length)}
        class="flex text-caption2 text-gray300 mt-1"
        data-ui="input_box#message"
      >
        <p class="group-data-[valid=invalid]/input-box:text-warning">
          {Monad.Result.unwrap_with_default(@error_message, @message)}
        </p>

        <%= if is_integer(@min_length) || is_integer(@max_length) do %>
          <span id={@id <> "_length"} phx-update="ignore" class="group-data-[valid=invalid]/input-box:text-warning ml-auto" data-ui="input_box#current_length" phx-hook={@hook}>0</span>
          &nbsp;/{@max_length}
        <% end %>
      </div>
    """
  end

  defp getValid(b) do
    case b do
      true -> "valid"
      false -> "invalid"
      _ -> nil
    end
  end

  def themes, do: @themes
end
