defmodule DeopjibWeb.Live.PayItemByPayer do
  alias DeopjibUtils.Debug
  alias Deopjib.Settlement
  alias DeopjibWebUI.Parts.{Button, Icon, Modal}
  use DeopjibWeb, :live_view

  def render(assigns) do
    ~H"""
      <div>
        <header class="h-12">

         <h2 class="h-full w-full grid place-content-center">
          <Button.render phx-click={Modal.show("room-name-change-modal")} class="flex px-2 py-1 items-center" theme={:text}>
            {@room.name}
            <Icon.render name={:pen} class="stroke-blue200 size-5 ml-px" />
          </Button.render>
         </h2>

         <Modal.modal id="room-name-change-modal" wrap_class="item-start justify-center">
            <:content_wrapper>
              <Modal.default_content_wrapper class="h-12 w-full gap-2 px-3 bg-white flex items-center">
                <Button.render class="size-11">취소</Button.render>

              </Modal.default_content_wrapper>
            </:content_wrapper>
          </Modal.modal>


        </header>

      </div>
    """
  end

  def mount(%{"room_short_id" => room_short_id}, session, socket) do
    case Settlement.get_room_by_short_id(room_short_id) do
      {:ok, room} ->
        {:ok, assign(socket, room: room)}

      _ ->
        {:error, "Room not found"}
    end
  end
end
