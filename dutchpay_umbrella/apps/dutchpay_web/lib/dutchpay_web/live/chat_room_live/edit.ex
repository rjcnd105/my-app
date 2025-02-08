defmodule DutchpayWeb.ChatRoomLive.Edit do
  @moduledoc false

  use DutchpayWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-auto w-96 mt-12">
      <.header>
        {@page_title}
        <%!-- <: 는 slot에 대한 heex 구문이다 --%>
        <:actions>
          <.link
            class="font-normal text-xs text-blue-600 hover:text-blue-700"
            navigate={~p"/rooms/#{@room}"}
          >
            Back
          </.link>
        </:actions>
      </.header>
      <%!-- phx-change는 값이 변경될때마다 실행되고, phx-submit은 submit을 할때 실행된다.--%>
      <.simple_form for={@form} id="room-form"phx-change="validate-room" phx-submit="save-room">
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:topic]} type="text" label="Topic" />
        <:actions>
          <.button phx-disable-with="Saving..." class="w-full">Save</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  def mount(%{"id" => id}, _session, socket) do
    room = Dutchpay.Chat.get_room!(id)
    # {:ok, assign(socket, page_title: "Edit chat room", room: room)}

    changeset = Dutchpay.Chat.change_room(room)

    socket =
      socket
      |> assign(page_title: "Edit chat room", room: room)
      # |> IO.inspect(label: "m1")
      |> assign_form(changeset)

    # |> IO.inspect(label: "m2")

    {:ok, socket}
  end

  # def handle_event("validate-room", %{"room" => room_params}, socket) do
  # changeset =
  #   socket.assigns.room
  #   |> IO.inspect()
  #   |> Dutchpay.Chat.change_room(room_params)

  # {:noreply, assign_form(socket, changeset)}
  # end
  def handle_event("validate-room", form, socket) do
    IO.inspect(form, label: "handle_event - form")

    changeset =
    socket.assigns.room
    |> Dutchpay.Chat.change_room(form["room_form_data"])
    |> Map.put(:action, :validate)

    # |> IO.inspect(label: "handle_event - socket.assigns.room")
    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save-room", %{"room_form_data" => room_params}, socket) do
    case Dutchpay.Chat.update_room(socket.assigns.room, room_params) do
      {:ok, room} ->
        {:noreply, socket |> put_flash(:info, "Room updated successfully") |> push_navigate(to: ~p"/rooms/#{room.id}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    value =
      changeset
      # |> IO.inspect(label: "assign_form - changeset")
      # as를 통해 이름을 지정하지 않으면, 마지막 모듈의 이름으로 자동 지정된다. (여기서는 "schema")
      # 가능한 as를 써서 명확하게 하는 것이 좋다.
      |> Phoenix.Component.to_form(as: "room_form_data")
      |> IO.inspect(label: "assign_form - to_form")

    assign(socket, :form, value)
  end
end
