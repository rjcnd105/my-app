defmodule DutchpayWeb.ChatRoomLive do
  @moduledoc false
  use DutchpayWeb, :live_view

  alias Dutchpay.Chat

  # 3 - render
  #

  def render(assigns) do
    ~H"""
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
          <h1 class="text-sm font-bold leading-none">
            <%!-- #{assigns.room.name} --%>
            <%!-- heex내에서 assigns를 생략할 수 있는 sugar가 제공된다. --%>
            #{@room.name}
          </h1>
          <div
            class={["text-xs leading-none h-3.5", !@hide_topic? && ["text-slate-500", "text-[10px]"]]}
            phx-click="toggle_topic"
          >
            <%!-- #{assigns.room.topic} --%>
            <%= if @hide_topic? do %>
              #{@room.topic}
            <% else %>
              [자세히 보기]
            <% end %>
          </div>
        </div>
      </div>
    </div>
    """
  end

  # 컴파일러에게 알려주기 위한 용도
  attr :active, :boolean, required: true
  attr :room, Chat.Room.Schema, required: true

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

    # socket.assigns에 :room이라는 키로 room값이 할당된다.
    # socket.assigns는 elixir 데이터를 저장할 수 있는 간단한 map이다.
    # 이는 render로 전달된다.
    {:ok, assign(socket, rooms: rooms)}
  end

  # 2 - handle_params
  # params가 업데이트 될때만 실행
  def handle_params(params, _uri, socket) do
    IO.puts("handle_params #{inspect(params)} (connected: #{connected?(socket)})")
    rooms = socket.assigns.rooms

    room =
      case Map.fetch(params, "id") do
        {:ok, id} ->
          %Dutchpay.Chat.Room.Schema{} = Enum.find(rooms, &(to_string(&1.id) == id))

        :error ->
          List.first(rooms)
      end

    IO.puts("mounting")

    if connected?(socket) do
      IO.puts("mounting (connected)")
    else
      IO.puts("mounting (not connected)")
    end

    {:noreply, assign(socket, hide_topic?: false, rooms: rooms, room: room)}
  end

  def handle_event("toggle_topic", _params, socket) do
    # {:noreply, assign(socket, hide_topic?: !socket.assigns.hide_topic?)}
    # 위의 코드 동작이랑 같음
    {:noreply, assign(socket, :hide_topic?, &(!&1))}
  end
end
