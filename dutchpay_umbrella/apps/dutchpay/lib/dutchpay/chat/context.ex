defmodule Dutchpay.Chat do
  @moduledoc false
  import Ecto.Query

  alias Dutchpay.Chat.{Message, Room}
  alias Dutchpay.Repo

  @doc false
  def list_rooms do
    Repo.all(from(Room.Schema, order_by: [desc: :updated_at]))
  end

  def get_room!(id) do
    Repo.get!(Room.Schema, id)
  end

  def create_room(attrs) do
    %Room.Schema{}
    # 제약 조건 검사
    # 패턴 매칭을 통해 { :ok, ... } 일때는 insert되고 { :error, ... } 일때는 insert되지 않는다.
    |> Room.Schema.changeset(attrs)
    |> Repo.insert()
  end

  def change_room(room, attrs \\ %{}) do
    Room.Schema.changeset(room, attrs)
  end

  def update_room(%Room.Schema{} = room, attrs) do
    room
    |> Room.Schema.changeset(attrs)
    |> Repo.update()
  end

  def list_messages_in_room(%Room.Schema{id: room_id}) do
    Message.Schema
    # 쿼리문은 매크로이다.
    # 매크로에서는 다른곳에서 전달되는 변수를 구분 할 수 없다.
    # 그러므로 ^를 붙혀서 보간해야 한다.
    # (X) where([m], m.room_id == room_id)
    # =~ SQL: SELECT * FROM messages WHERE room_id = room_id
    # (O) where([m], m.room_id == ^room_id)
    # =~ SQL: SELECT * FROM messages WHERE room_id = 1
    #
    # ^를 붙힌다면 전달되는 값을 구분하기 떄문에 이름이 같아도 된다.
    # where([m], m.room_id == ^m)
    |> where([m], m.room_id == ^room_id)
    # preload를 시켜야 belongs_to 등으로 연결된 스키마를 가져올 수 있다.
    # @see Dutchpay.Chat.Message.Schema
    |> preload(:user)
    # |> preload(:room)
    |> order_by([m], asc: :inserted_at, asc: :id)
    |> Repo.all()

    # 선언형으로 작성할 수도 있다.
    # from(m in Message.Schema,
    #   where: m.room_id == ^room_id,
    #   order_by: [asc: :inserted_at, asc: :id]
    # )
  end

  def change_message(message, attrs \\ %{}) do
    Message.Schema.changeset(message, attrs)
  end

  def create_message(room, attrs, user) do
    %Message.Schema{room: room, user: user}
    |> change_message(attrs)
    |> Repo.insert()
  end
end
