defmodule DeopjibWeb.Live.CreateRoom do
  use DeopjibWeb, :live_view
  alias Deopjib.Settlement.{Payer, Room}
  alias DeopjibWebUI.Templates.Main
  alias DeopjibWebUI.Parts.{InputBox, Button, Chip}

  def render(assigns) do
    name_length = Payer.name_length()
    is_once_valid = assigns.payer_form.action == :validate
    has_errors = assigns.payer_form.errors != []
    user_count = length(assigns.users)
    is_user_full = user_count >= 10
    max_payer = Deopjib.Settlement.Room.max_payer()

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

      <.form phx-submit="add_temp_payer" phx-change="payer_validate" for={@payer_form} onkeydown="return event.key != 'Enter';">
        <InputBox.render
          valid={if @is_once_valid, do: !@add_disabled, else: nil}
          theme={:big_rounded_border}
          field={@payer_form[:name]}
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
          <span class="">{@user_count}명</span>/{max_payer}명
        </div>
        <div>
          <.form phx-submit="create_room_with_payer">
            <Button.render theme={:primary} size={:xlg} class="w-full mt-1" type="submit" disabled={@user_count == 0 || @is_user_full}>
          다음
          </Button.render>
          </.form>
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

    payer_form =
      AshPhoenix.Form.for_create(Payer, :create)
      |> to_form()

    room_form =
      AshPhoenix.Form.for_create(Room, :create_with_payers)
      |> to_form()

    {:ok,
     assign(socket,
       payer_form: payer_form,
       room_form: room_form,
       users: []
     )}
  end

  def handle_event("user_delete", %{"name" => name}, socket) do
    {:noreply,
     assign(socket,
       users: Enum.reject(socket.assigns.users, &(&1[:name] == name))
     )}
  end

  def handle_event("payer_validate", %{"form" => form_params}, socket) do
    payer_form =
      AshPhoenix.Form.validate(socket.assigns.payer_form, form_params)
      |> Map.put(:action, :validate)
      |> dbg_store()

    {:noreply,
     assign(socket,
       payer_form: payer_form
     )}
  end

  def handle_event("add_temp_payer", %{"form" => %{"name" => name} = form_params}, socket) do
    users = socket.assigns.users
    payer_form = socket.assigns.payer_form

    form =
      AshPhoenix.Form.validate(socket.assigns.payer_form, form_params)

    socket =
      if(form.errors == []) do
        room_form =
          socket.assigns.room_form
          |> AshPhoenix.Form.add_form(
            [:payers],
            params: %{name: name}
          )

        dbg_store(room_form)

        socket
        |> assign(
          users: Enum.uniq_by(users ++ [%{name: name}], & &1[:name]),
          payer_form: AshPhoenix.Form.clear_value(payer_form, :name),
          room_form: room_form
        )
      else
        socket
      end

    {:noreply, socket}
  end

  def handle_event("create_room_with_payer", unsigned_params, socket) do
  end
end
