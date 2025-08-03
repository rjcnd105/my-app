defmodule DeopjibWeb.Live.PayItemByPayer do
  alias Phoenix.LiveView.AsyncResult
  alias DeopjibUtils.Debug
  alias Deopjib.Settlement
  alias Deopjib.Settlement.{Payer, PayItem}
  alias DeopjibWebUI.Parts.{Button, Icon, Modal, InputBox, Overlay}
  alias Monad.Result, as: R
  use DeopjibWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="grid grid-rows-[--spacing(12)_--spacing(9)_1fr] h-full">
      <header ui-layout="app" class="sticky top-0">
        <%= if @is_room_loading do %>
          <.header_contents room={@room} room_name_form={@room_name_form} />
        <% end %>
      </header>

      <ul ui-layout="app" class="flex gap-1 pl-5 pr-2">
        <li>
          <Button.render theme={:ghost} size={:lg} is_rounded>
            <Icon.render name={:pen} class="stroke-blue300 size-6 stroke-2" />
          </Button.render>
        </li>
        <%= if @selected_payer do %>
          <li :for={payer <- @room.payers}>
            <Button.render
              theme={:gray}
              size={:lg}
              is_rounded
              data-selected={payer.id == @selected_payer.id}
            >
              {payer.name}
            </Button.render>
          </li>
        <% end %>
      </ul>

      <div class="flex flex-col flex-1 mt-2 bg-lightgray100">
        <%= if !is_nil(@selected_payer) do %>
          <div ui-layout="app" class="flex justify-between pt-2 shrink-0">
            <div>
              <div class="flex items-center">
                <strong class="h-13 text-heading font-bold">{@selected_payer.total_paid || 0}</strong>
                <span class="ml-1 text-body1 font-bold">원</span>
              </div>
              <Button.render class="flex items-center  h-5">
                <Icon.render
                  name={:plus}
                  class="size-3 stroke-gray300 stroke-2 border-gray300 border-1 rounded-[2px]"
                />
                <span class="ml-1.5 text-darkgray100 text-caption2">계좌 추가</span>
              </Button.render>
            </div>
            <span class="text-darkgray100 text-caption3 text-right self-end">
              마지막 업데이트<br />
              {DeopjibUtils.Date.simple_datetime_format(@room.updated_at)}
            </span>
          </div>
          <div ui-layout="app">
            <hr class="bg-black mt-4 h-0.5 shrink-0" />
          </div>
          <div ui-layout="app" class="flex flex-col flex-auto">
            <span
              :if={length(@selected_payer.settled_items) == 0}
              class="flex flex-auto justify-center items-center pb-40 text-gray300 text-caption1"
            >
              등록한 내역이 없어!
            </span>
          </div>
        <% end %>
      </div>
    </div>

    <%= if !is_nil(@selected_payer) do %>
      <Modal.draw id="add-pay-item-modal" wrap_class="item-start self-end" show>
        <:content_wrapper>
          <Modal.default_content_wrapper class="pt-3 pb-1 w-full px-3 bg-white ">
            <.form
              ui-layout="app"
              class="flex flex-col w-full h-full gap-1 group/form"
              for={@pay_items_form}
              phx-submit="change_room_name"
              onkeydown="return event.key != 'Enter';"
            >
              <span class="text-darkgray100 text-caption2">입력 예) 택시/12,000</span>
              <InputBox.render
                placeholder="원하는 영수증 제목"
                theme={:big_rounded_border}
                field={@pay_items_form[:words]}
                container_class="flex-auto"
                has_close={false}
                required={true}
              >
                <:input_right>
                  <Button.render theme={:dark} size={:md} class="ml-0.5" type="submit">
                    추가
                  </Button.render>
                </:input_right>
                <%!-- <:message_line :let={error_message}>
                  <InputBox.messages error_message={error_message} max_length={8} min_length={0} />
                </:message_line> --%>
              </InputBox.render>
            </.form>
          </Modal.default_content_wrapper>
        </:content_wrapper>
      </Modal.draw>
    <% end %>
    """
  end

  def mount(%{"room_short_id" => room_short_id}, _, socket) do
    {:ok,
     socket
     |> assign(
       is_room_loading: false,
       selected_payer: nil,
       pay_items_form:
         AshPhoenix.Form.for_create(Settlement.PayItem, :upsert_from_words) |> to_form()
     )
     |> start_async(:get_room, fn ->
       Settlement.get_room_by_short_id!(room_short_id,
         load: [
           payers:
             Payer
             |> Ash.Query.select([:id, :name])
             |> Ash.Query.load([:settled_items, :total_paid])
         ],
         # load: [payers: [:id, :name]],
         query: [select: [:id, :name, :updated_at]]
       )
     end)}
  end

  def handle_async(:get_room, {:ok, room}, socket) do
    first_selected_payer =
      case room.payers do
        [first_payer | _] -> first_payer
        _ -> nil
      end

    {:noreply,
     socket
     |> assign(
       room: room,
       room_name_form:
         room
         |> AshPhoenix.Form.for_update(:update_name, api: Settlement.Room)
         |> to_form(),
       selected_payer: first_selected_payer,
       is_room_loading: true
     )
     |> Debug.dbg_store()}
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
        <Modal.default_content_wrapper class="shadow-1 h-12 w-full px-3 bg-white ">
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
