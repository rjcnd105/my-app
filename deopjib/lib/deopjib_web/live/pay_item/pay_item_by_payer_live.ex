defmodule DeopjibWeb.Live.PayItemByPayer do
  alias Phoenix.LiveView.AsyncResult
  alias DeopjibUtils.Debug
  alias Deopjib.Settlement
  alias DeopjibWebUI.Parts.{Button, Icon, Modal, InputBox, Overlay}
  alias Monad.Result, as: R
  use DeopjibWeb, :live_view

  def render(assigns) do
    ~H"""
    <header class="h-12">
     <%= if @is_room_loading do %>
       <.header_contents room={@room} room_name_form={@room_name_form} />
     <% end %>
    </header>

    <ul class="flex mt-1 gap-1">
      <li>
        <Button.render theme={:ghost} size={:lg} is_rounded >
          <Icon.render name={:pen} class="stroke-blue300 size-6 stroke-2" />
        </Button.render>
      </li>
      <%= if @is_room_loading do %>
        <li :for={payer <- @room.payers}>
          <Button.render theme={:gray} size={:lg} is_rounded data-selected={payer.id == @selected_payer_id}>
            {payer.name}
          </Button.render>
        </li>
      <% end %>
    </ul>
    """
  end

  def mount(%{"room_short_id" => room_short_id}, _, socket) do
    {:ok,
     socket
     |> assign(is_room_loading: false)
     |> start_async(:get_room, fn ->
       Settlement.get_room_by_short_id!(room_short_id,
         load: [payers: Payer |> Ash.Query.select([:id, :name])],
         query: [select: [:id, :name]]
       )
     end)}
  end

  def handle_async(:get_room, {:ok, room}, socket) do
    {:noreply,
     assign(socket,
       room: room,
       room_name_form:
         room
         |> AshPhoenix.Form.for_update(:update_name, api: Settlement.Room)
         |> to_form(),
       selected_payer_id:
         case room.payers do
           [first_payer | _] -> first_payer.id
           _ -> nil
         end,
       is_room_loading: true
     )}

    # {:noreply, socket}
  end

  def handle_event("change_room_name", %{"form" => %{"name" => name} = form_params}, socket) do
    socket =
      case AshPhoenix.Form.submit(socket.assigns.room_name_form, params: form_params) do
        {:ok, room} ->
          socket
          |> assign(room: room)
          |> push_event("js-exec", %{
            to: "#room-name-change-modal",
            attr: "phx-hide"
          })

        {:error, form} ->
          socket |> assign(room_name_form: form)
      end

    {:noreply, socket}
  end

  defp header_contents(assigns) do
    ~H"""
    <h2 class=" h-full w-full grid place-content-center grid-rows-1">
      <Button.render
        phx-click={
          Overlay.show("room-name-change-modal")
          |> JS.set_attribute({"value", @room_name_form[:name].value},
            to: "##{@room_name_form[:name].id}"
          )
        }
        class="flex px-2 h-full items-center"
        theme={:text}
      >
        {@room.name}
        <Icon.render name={:pen} class="stroke-blue200 size-5 ml-px" />
      </Button.render>
    </h2>

    <Modal.modal id="room-name-change-modal" wrap_class="item-start justify-center">
      <:content_wrapper>
        <Modal.default_content_wrapper class="h-12 w-full px-3 bg-white ">
          <.form
            class="flex w-full h-full items-center gap-1 group/form"
            for={@room_name_form}
            phx-submit="change_room_name"
            onkeydown="return event.key != 'Enter';"
          >
            <Button.render
              class="size-11 cursor-pointer"
              phx-click={Overlay.hide(%JS{}, "room-name-change-modal")}
            >
              취소
            </Button.render>
            <InputBox.render
              placeholder="원하는 영수증 제목"
              class="text-center"
              field={@room_name_form[:name]}
              container_class="flex-auto pr-[37px]"
              has_close={false}
              phx-mounted={JS.dispatch("addEvent:inputMaxLengthLimit", detail: %{max_length: 13})}
              required={true}
            />
            <Button.render class="flex size-11 px-2 py-1 items-center" type="submit" theme={:text}>
              저장
            </Button.render>
          </.form>
        </Modal.default_content_wrapper>
      </:content_wrapper>
    </Modal.modal>
    """
  end
end
