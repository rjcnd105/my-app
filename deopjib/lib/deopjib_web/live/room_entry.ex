defmodule DeopjibWeb.Live.RoomEntry do
  use DeopjibWeb, :live_view
  alias Deopjib.Settlement
  alias DeopjibWebUI.Templates.Main
  alias DeopjibWebUI.Parts.{InputBox, Button, Chip}

  def render(assigns) do
    name_length = Settlement.Payer.name_length()
    is_once_valid = assigns.form.action == :validate
    has_errors = assigns.form.errors != []
    user_count = length(assigns.users)
    is_user_full = user_count >= 10

    assigns =
      assigns
      |> assign(
        is_once_valid: is_once_valid,
        user_count: user_count,
        is_user_full: is_user_full,
        add_disabled: !is_once_valid || has_errors || is_user_full
      )

    # |> IO.inspect(label: "room_entry-render")

    ~H"""
    <Main.render class="pt-8 flex flex-col h-full">
      <h2 class="text-title font-light mb-4">누구누구 정산할거야?</h2>

      <.form phx-submit="add_temp_user" phx-change="validate" for={@form} onkeydown="return event.key != 'Enter';">
        <InputBox.render
          valid={if @is_once_valid, do: !@add_disabled, else: nil}
          theme={:big_rounded_border}
          field={@form[:name]}
          placeholder="정산할 사람 이름"
          max_length={name_length[:max]}
          min_length={name_length[:min]}
          phx-debounce={300}
        >
         <:input_right>
          <Button.render theme={:dark} size={:md} class="ml-0.5" type="submit" disabled={@add_disabled}>
            추가
          </Button.render>
         </:input_right>
        </InputBox.render>

      </.form>

      <div class="mt-4 flex flex-1 content-start flex-wrap gap-x-2 gap-y-3">
        <Chip.render
          :for={user <- @users}
          theme={:gray}
          phx-click="user_delete"
          phx-value-name={user.name}
          wrap_class="animate-wiggle"

        >{user.name}</Chip.render>
      </div>

      <div class="sticky bottom-4 left-0">
        <div class="text-darkgray100 text-caption1">
          <span class="">{@user_count}명</span>/{Deopjib.Settlement.Room.max_payer()}명
        </div>
        <div>
          <Button.render theme={:primary} size={:xlg} class="w-full mt-1" type="submit" disabled={@user_count == 0 || @is_user_full}>
          다음
          </Button.render>
        </div>
      </div>


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
       form: Deopjib.Settlement.form_to_create_room() |> to_form(),
       users: []
     )}
  end

  def handle_event("user_delete", %{"name" => name}, socket) do
    {:noreply,
     assign(socket,
       users: Enum.reject(socket.assigns.users, &(&1[:name] == name))
     )}
  end

  def handle_event("validate", %{"form" => form_params}, socket) do
    form =
      AshPhoenix.Form.validate(socket.assigns.form, form_params)
      |> Map.put(:action, :validate)
      |> dbg_store()

    {:noreply,
     assign(socket,
       form: form
     )}
  end

  def handle_event("add_temp_user", %{"form" => form_params}, socket) do
    users = socket.assigns.users
    name = form_params["name"]

    form =
      AshPhoenix.Form.validate(socket.assigns.form, form_params)

    socket =
      if(form.errors == []) do
        socket
        |> assign(
          users: Enum.uniq_by(users ++ [%{name: name}], & &1[:name]),
          form: Deopjib.Settlement.form_to_create_payer() |> to_form()
        )
      else
        socket
      end

    {:noreply, socket}
  end

  def handle_event(event, unsigned_params, socket) do
  end
end
