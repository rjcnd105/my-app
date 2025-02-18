defmodule DutchpayWeb.ChatRoomLive do
  @moduledoc false
  alias Dutchpay.Chat.Message
  use DutchpayWeb, :live_view

  alias Dutchpay.Chat

  # 3 - render
  #

  def render(assigns) do
    ~H"""
    <div class="flex flex-1">
      <div class="flex flex-col shrink-0 w-64 bg-slate-100">
        <div class="flex justify-between items-center shrink-0 h-16 border-b border-slate-300 px-4">
          <div class="flex flex-col gap-1.5">
            <h1 class="text-lg font-bold text-gray-800">
              Dutchpay Chat Rooms
            </h1>
          </div>
        </div>
        <div class="mt-4 overflow-auto">
          <div class="flex items-center h-8 px-3">
            <span class="ml-2 leading-none font-medium text-sm">Rooms</span>
          </div>
          <div id="rooms-list">
            <.room_link :for={room <- @rooms} room={room} active={room.id == @room.id} />
          </div>
        </div>
      </div>
      <div class="flex flex-col grow shadow-lg">
        <div class="flex justify-between items-center shrink-0 h-16 bg-white border-b border-slate-300 px-4">
          <div class="flex flex-col gap-1.5">
            <h2 class="text-sm font-bold leading-none">
              <%!-- #{assigns.room.name} --%>
              <%!-- heex내에서 assigns를 생략할 수 있는 sugar가 제공된다. --%>
              #{@room.name}
              <%!-- 다른 LiveView 모듈이기 때문에 patch가 아닌 navigate로 해야한다. --%>
              <.link
                class="font-normal text-xs text-blue-600 hover:text-blue-700"
                navigate={~p"/rooms/#{@room}/edit"}
              >
                edit
              </.link>
            </h2>
            <div
              class={[
                "text-xs leading-none h-3.5",
                !@hide_topic? && ["text-slate-500", "text-[10px]"]
              ]}
              phx-click="toggle_topic"
            >
              <%= if @hide_topic? do %>
                #{@room.topic}
              <% else %>
                [자세히 보기]
              <% end %>
            </div>
          </div>
          <ul class="relative z-10 flex items-center gap-4 pl-4 sm:pl-6 lg:pl-8 justify-end">
            <li class="text-[0.8125rem] leading-6 text-zinc-900">
              {@current_user.email}
            </li>
            <li>
              <.link
                href={~p"/users/settings"}
                class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
              >
                Settings
              </.link>
            </li>
            <li>
              <.link
                href={~p"/users/log_out"}
                method="delete"
                class="text-[0.8125rem] leading-6 text-zinc-900 font-semibold hover:text-zinc-700"
              >
                Log out
              </.link>
            </li>
          </ul>
        </div>
        <div id="room-messages" class="flex flex-col grow overflow-auto" phx-update="stream">
          <%!-- <.message :for={message <- @messages} message={message} /> --%>
          <.message
            :for={{dom_id, message} <- @streams.messages}
            dom_id={dom_id}
            message={message}
            current_user={@current_user}
            timezone={@timezone}
          />
        </div>

        <div class="h-12 bg-white px-4 pb-4">
          <.form
            id="new-message-form"
            for={@new_message_form}
            class="flex item-center border-2 border-slate-300 rounded-sm p-1"
            phx-change="validate-message"
            phx-submit="submit-message"
          >
            <textarea
              class="grow text-sm px-1 outline-0 border-slate-300 overflow-hidden resize-none"
              id="chat-message-textarea"
              name={@new_message_form[:body].name}
              placeholder={"Message ##{@room.name}"}
              phx-debounce={500}
              rows="1"
            >{Phoenix.HTML.Form.normalize_value("textarea", @new_message_form[:body].value)}</textarea>
            <button class="shrink flex items-center justify-center size-6 rounded-md hover:bg-slate-200">
              <.icon name="hero-paper-airplane" class="size-4" />
            </button>
          </.form>
        </div>
      </div>
    </div>
    """
  end

  # 컴파일러에게 알려주기 위한 용도
  attr(:active, :boolean, required: true)
  attr(:room, Chat.Room.Schema, required: true)

  defp room_link(assigns) do
    ~H"""
    <%!-- ~p를 사용하여 검증된 애플리케이션의 경로를 나타내는 문자열을 생성한다. 라우터에 대한 경로를 확인하여 실제로 존재하는지 확인하고, 존재하지 않으면 경고를 표시한다. --%>
    <%!-- ~p"/rooms/#{@room}"을 하면 기본적으로 @room.id이다. --%>
    <%!-- .link는 a를 대신한다, 기존 연결된 소켓이 있는 경우 최대한 기존 웹소켓을 사용하도록 한다.  --%>

    <%!-- # navigate={~p"/rooms/#{@room.id}"} --%>
    <%!-- # patch로 하면 현재와 동일한 모듈인 경우에 사용가능하고
    mount 단계를 건너뛴다. --%>
    <.link
      class={[
        "flex items-center h-8 text-sm pl-8 pr-3",
        (@active && "bg-slate-300") || "hover:bg-slate-300"
      ]}
      patch={~p"/rooms/#{@room.id}"}
    >
      <%!-- <DutchpayWeb.CoreComponents.icon name="hero-hashtag" class="h-4 w-4" /> --%>
      <%!--  Hero Icons를 라이브러리를 가리키고 위와 같다 --%>
      <.icon name="hero-hashtag" class="h-4 w-4" />
      <span class={["ml-2 leading-none", @active && "font-bold"]}>
        {@room.name}
      </span>
    </.link>
    """
  end

  # 생명주기
  # mount -> handle_params -> render

  # 1 - mount
  def mount(_params, _session, socket) do
    rooms = Chat.list_rooms()

    if connected?(socket) do
      IO.puts("mounting (connected)")
    else
      IO.puts("mounting (not connected)")
    end

    timezone = get_connect_params(socket)["timezone"]
    # socket.assigns에 :room이라는 키로 room값이 할당된다.
    # socket.assigns는 elixir 데이터를 저장할 수 있는 간단한 map이다.
    # 이는 render로 전달된다.
    {:ok, assign(socket, rooms: rooms, timezone: timezone)}
  end

  # 2 - handle_params
  # params가 업데이트 될때만 실행
  def handle_params(params, _session, socket) do
    IO.puts("handle_params #{inspect(params)} (connected: #{connected?(socket)})")
    rooms = socket.assigns.rooms

    # 찾은 room의 id를 넣음, 없을 경우 리스트의 첫번째를 넣음
    room =
      case Map.fetch(params, "id") do
        {:ok, id} ->
          Dutchpay.Chat.get_room!(id)

        :error ->
          List.first(rooms)
      end

    messages = Dutchpay.Chat.list_messages_in_room(room)
    IO.inspect(messages, label: "messages")

    IO.puts("mounting")

    if connected?(socket) do
      IO.puts("mounting (connected)")
    else
      IO.puts("mounting (not connected)")
    end

    socket =
      socket
      |> assign(
        hide_topic?: false,
        room: room,
        page_title: "#" <> room.name
      )
      # stream으로 하면 socket.assign에 저장하지 않고 한번 렌더링하고 지운다.
      # 그로 인해 서버 부하를 줄일 수 있다.
      # 큰 리스트같은 경우에 유용하다.
      |> stream(:messages, messages, reset: true)
      # message form 초기화
      |> assign_message_form(Chat.change_message(%Message.Schema{}))

    {:noreply, socket}
    # {:noreply,
    #  assign(socket,
    #    hide_topic?: false,
    #    rooms: rooms,
    #    room: room,
    #    messages: messages,
    #    page_title: "#" <> room.name
    #  )}
  end

  # 웹 요청에서 받는 form은 atom이 아닌 문자열 키를 가지고 있으므로 이렇게 패턴 매칭해야함.
  def handle_event("validate-message", %{"message" => message_params}, socket) do
    changeset =
      %Chat.Message.Schema{}
      |> Chat.change_message(message_params)

    {:noreply, assign_message_form(socket, changeset)}
  end

  def handle_event("submit-message", %{"message" => message_params}, socket) do
    %{current_user: current_user, room: room} = socket.assigns

    socket =
      case Chat.create_message(room, message_params, current_user) do
        {:ok, message} ->
          socket
          # |> IO.inspect(label: "msg")
          ## none stream 방식일 경우
          # |> update(:messages, &(&1 ++ [message]))

          # stream 할당인 경우 @message는 존재하지 않으므로 업데이트할 수 없다.
          # 기본적으로 stream_insert/3 은 컬렉션 끝에 새 항목을 삽입합니다.
          |> stream_insert(:messages, message)
          |> assign_message_form(Chat.change_message(%Chat.Message.Schema{}))

        {:error, changeset} ->
          assign_message_form(socket, changeset)
      end

    {:noreply, socket}
  end

  def handle_event("toggle_topic", _params, socket) do
    socket =
      socket
      |> update(:hide_topic?, &(!&1))

    {:noreply, assign(socket, hide_topic?: !socket.assigns.hide_topic?)}

    # 아래 코드는 assign의 3번째 인자 함수가 처리된 값이 한번 평가되고 재평가되지 않는다.
    # {:noreply, assign(socket, :hide_topic?, &(!&1))}
  end

  def handle_event("delete-message", %{"id" => message_id}, socket) do
    {:ok, message} = Chat.delete_message_by_id(message_id, socket.assigns.current_user)

    socket = stream_delete(socket, :messages, message)
    {:noreply, socket}
  end

  attr(:dom_id, :string, required: true)
  attr(:current_user, Dutchpay.Accounts.User, required: true)
  attr(:message, Dutchpay.Chat.Message.Schema, required: true)
  attr(:timezone, :string, required: true)

  defp message(assigns) do
    ~H"""
    <div id={@dom_id} class="group/message relative flex px-4 py-3 hover:bg-gray-100">
      <div class="h-10 w-10 rounded shrink-0 bg-slate-300"></div>
      <div class="ml-2">
        <div class="-mt-1">
          <.link class="text-sm font-semibold hover:underline">
            <span>{get_user_name_from_email(@message.user)}</span>
          </.link>
          <span :if={@timezone} class="ml-1 text-xs text-gray-500">
            {message_timestamp(@message, @timezone)}
          </span>
          <p class="text-sm">{@message.body}</p>
        </div>
      </div>
      <button
        :if={@current_user.id == @message.user.id}
        class="absolute invisible group-hover/message:visible top-50p right-4 text-red-500 hover:text-red-800 cursor-pointer"
        data-confirm="정말 메시지를 삭제하시겠습니까?"
        phx-click="delete-message"
        phx-value-id={@message.id}
      >
        <.icon name="hero-trash" class="h-4 w-4" />
      </button>
    </div>
    """
  end

  defp assign_message_form(socket, changeset) do
    socket
    |> assign(:new_message_form, to_form(changeset, as: "message"))
  end

  defp get_user_name_from_email(%Dutchpay.Accounts.User{} = user) do
    user.email |> String.split("@") |> List.first() |> String.capitalize()
  end

  defp message_timestamp(message, timezone) do
    message.inserted_at
    |> Timex.Timezone.convert(timezone)
    |> Timex.format!("%-l:%M %p", :strftime)
  end
end
