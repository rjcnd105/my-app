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

  attr(:theme, :atom, values: @themes, default: :none)
  attr(:has_close, :boolean, default: true)
  attr(:valid, :any, default: nil)
  attr(:field, Phoenix.HTML.FormField)
  attr(:box_class, :any, default: nil)
  attr(:id, :any)
  attr(:name, :any)
  attr(:value, :any, default: nil)
  attr(:errors, :list, default: [])
  attr(:message, :string, default: "")
  attr(:min_length, :integer, default: nil)
  attr(:max_length, :integer, default: nil)
  attr(:rest, :global, include: ~w(placeholder))
  attr(:error_message, :any, default: nil)

  slot(:input_right)

  def render(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil)
    |> assign(id: assigns[:id] || field.id)
    |> assign_new(:name, fn -> field.name end)
    |> assign_new(:value, fn -> field.value end)
    # |> IO.inspect(label: "input_box before")
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
      |> assign(:theme_class, @theme_classes[assigns.theme])

    # |> IO.inspect(label: "input_box")

    ~H"""
    <div
      class="group/input-box"
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
            class="peer flex flex-1 h-full bg-none p-0 placeholder:text-body2 placeholder:text-gray200 ring-0 border-none"
            phx-mounted={JS.dispatch("addEvent:enter-submit", detail: %{event_name: "keyup"})}
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
      <div
        :if={is_binary(@message) || is_integer(@max_length) || is_integer(@min_length)}
        class="flex text-caption2 text-gray300 mt-1"
        data-ui="input_box#message"
      >
        <p class="group-data-[valid=invalid]/input-box:text-warning">
          {Monad.Result.unwrap_with_default(@error_message, @message)}
        </p>

        <%= if is_integer(@min_length) || is_integer(@max_length) do %>
          <span id={@id <> "_length"} phx-update="ignore" class="group-data-[valid=invalid]/input-box:text-warning ml-auto" data-ui="input_box#current_length" phx-hook="InputBoxLengthHook">0</span>
          &nbsp;/{@max_length}
        <% end %>
      </div>
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
