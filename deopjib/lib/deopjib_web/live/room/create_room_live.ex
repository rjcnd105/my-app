defmodule DeopjibWeb.Live.CreateRoom do
  use DeopjibWeb, :live_view
  alias Deopjib.Settlement.{Payer, Room}
  alias DeopjibWebUI.Templates.Main
  alias DeopjibUtils.Debug
  alias DeopjibWebUI.Parts.{InputBox, Button, Chip, Toast}

  def render(assigns) do
    name_length = Payer.name_length()
    is_once_valid = assigns.payer_form.action == :validate
    has_payer_errors = assigns.payer_form.errors != []
    max_payer = Deopjib.Settlement.Room.max_payer()
    payers = assigns.room_form.forms[:payers] || []
    user_count = Enum.count(payers)

    assigns =
      assigns
      |> assign(
        is_once_valid: is_once_valid,
        user_count: user_count,
        add_disabled: !is_once_valid || has_payer_errors,
        payers: payers
      )

    ~H"""
    <Main.render class="pt-8 flex flex-col h-full">
      <h2 class="text-title font-light mb-4">누구누구 정산할거야?</h2>

      <.form
        phx-submit="add_temp_payer"
        phx-change="payer_validate"
        for={@payer_form}
        onkeydown="return event.key != 'Enter';"
      >
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
            <Button.render
              theme={:dark}
              size={:md}
              class="ml-0.5"
              type="submit"
              disabled={@add_disabled}
            >
              추가
            </Button.render>
          </:input_right>
        </InputBox.render>
      </.form>
      <div class="mt-4 flex flex-1 content-start flex-wrap gap-x-2 gap-y-3">
        <Chip.render
          :for={payer <- @payers}
          theme={:gray}
          phx-click="delete_temp_payer"
          phx-value-id={payer.id}
          phx-value-name={payer.params.name}
          wrap_class="animate-wiggle"
        >
          {payer.params.name}
        </Chip.render>
      </div>
      <div class="sticky bottom-4 left-0">
        <div class="text-darkgray100 text-caption1">
          <span>{@user_count}명</span>/{max_payer}명
        </div>
        <div>
          <.form for={@room_form} phx-submit="create_room_with_payer">
            <Button.render
              theme={:primary}
              size={:xlg}
              class="w-full mt-1"
              type="submit"
              disabled={@user_count == 0}
            >
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
      AshPhoenix.Form.for_create(Room, :upsert_with_payers)

    {:ok,
     assign(socket,
       payer_form: payer_form,
       room_form: room_form
     )}
  end

  def handle_event("delete_temp_payer", %{"name" => _name, "id" => id}, socket) do
    {:noreply,
     update(
       socket,
       :room_form,
       &remove_payer_for_form(&1, id)
     )}
  end

  def handle_event("payer_validate", %{"form" => form_params}, socket) do
    payer_form =
      AshPhoenix.Form.validate(socket.assigns.payer_form, form_params)
      |> Map.put(:action, :validate)

    {:noreply,
     assign(socket,
       payer_form: payer_form
     )}
  end

  def handle_event("add_temp_payer", %{"form" => %{"name" => name} = form_params}, socket) do
    form =
      AshPhoenix.Form.validate(socket.assigns.payer_form, form_params)

    socket |> IO.inspect(label: "before socket")

    socket =
      if(form.errors == []) do
        room_added_form =
          socket.assigns.room_form
          |> AshPhoenix.Form.add_form(
            [:payers],
            params: %{name: name},
            validate?: true
          )

        room_form =
          case room_added_form do
            %{valid?: true} ->
              room_added_form

            %{valid?: false} = failed_form ->
              socket.assigns.room_form
          end
          |> dbg_store()

        socket =
          socket
          |> assign(
            payer_form: AshPhoenix.Form.for_create(Payer, :create) |> to_form(),
            room_form: room_form
          )

        if room_added_form.source.errors != [] do
          push_event(socket, "toast/open", %{
            message: hd(room_added_form.source.errors).message
          })
        else
          socket
        end
      else
        socket
      end

    socket |> IO.inspect(label: "socket")

    {:noreply, socket}
  end

  def handle_event("create_room_with_payer", _params, socket) do
    submitted_room_form =
      socket.assigns.room_form
      |> AshPhoenix.Form.submit()

    case(submitted_room_form) do
      {:ok, room} ->
        {:noreply, push_navigate(socket, to: ~p"/#{room.short_id}/add_pay_items")}

      {:error, form} ->
        {:noreply,
         socket
         |> assign(:room_form, form)
         |> push_event("toast/open", %{
           message: hd(form.errors).message
         })}
    end
  end

  defp remove_payer_for_form(%AshPhoenix.Form{} = form, id) do
    index = Enum.find_index(form.forms.payers, &(&1.id == id))

    form
    |> AshPhoenix.Form.remove_form(
      [:payers, index],
      validate?: false
    )
  end
end
