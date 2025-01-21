defmodule Dutchpay.Chat do
  @moduledoc false
  import Ecto.Query

  alias Dutchpay.Chat.Room
  alias Dutchpay.Repo

  @doc false
  def list_rooms do
    Repo.all(from(Room.Schema, order_by: [desc: :updated_at]))
  end

  def create_room(attrs) do
    %Room.Schema{}
    # 제약 조건 검사
    # 패턴 매칭을 통해 { :ok, ... } 일때는 insert되고 { :error, ... } 일때는 insert되지 않는다.
    |> Room.Schema.changeset(attrs)
    |> Repo.insert()
  end
end
