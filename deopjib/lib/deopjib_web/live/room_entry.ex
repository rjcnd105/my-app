defmodule DeopjibWeb.Live.RoomEntry do
  alias DeopjibWeb.CoreComponents
  alias Deopjib.Settlement
  use DeopjibWeb, :live_view
  alias DeopjibWebUI.Templates.Main
  alias DeopjibWebUI.Parts.{InputBox, Button}

  def render(assigns) do
    name_length = Settlement.Payer.name_length()
    is_once_valid = assigns.form.action == :validate
    has_errors = assigns.form.errors != []

    assigns =
      assigns
      |> assign(submit_disabled: !is_once_valid || has_errors, is_once_valid: is_once_valid)

    # |> IO.inspect(label: "room_entry-render")

    ~H"""
    <Main.render class="mt-8">
      <h2 class="text-title font-light mb-4">누구누구 정산할거야?</h2>

      <.form phx-submit="submit" phx-change="validate" for={@form}>
        <InputBox.render
          valid={if @is_once_valid, do: !@submit_disabled, else: nil}
          theme={:big_rounded_border}
          field={@form[:name]}
          placeholder="정산할 사람 이름"
          max_length={name_length[:max]}
          min_length={name_length[:min]}
          phx-debounce={300}
        >
         <:input_right>
          <Button.render theme={:dark} size={:md} class="ml-0.5" type="submit" disabled={@submit_disabled}>
            추가
          </Button.render>
         </:input_right>
        </InputBox.render>

      </.form>


    </Main.render>
    """
  end

  def submit(params, socket) do
    IO.inspect(params, label: "submit-params")
    {:noreply, socket}
  end

  def mount(_params, _session, socket) do
    # Here we call our new generated function to create the form
    {:ok,
     assign(socket,
       form: Deopjib.Settlement.form_to_create_payer() |> to_form()
     )}
  end

  def handle_event("validate", %{"form" => form_params}, socket) do
    form =
      AshPhoenix.Form.validate(socket.assigns.form, form_params)
      # |> IO.inspect(label: "validate-form")
      |> Map.put(:action, :validate)

    {:noreply,
     assign(socket,
       form: form
     )}
  end
end
