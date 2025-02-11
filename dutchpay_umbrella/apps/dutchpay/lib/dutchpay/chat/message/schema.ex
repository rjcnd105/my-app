defmodule Dutchpay.Chat.Message.Schema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :body, :string

    # 다른 스키마 연결
    # forign_key를 통해서 이름을 변경할 수 있다.
    belongs_to :room, Dutchpay.Chat.Room.Schema, foreign_key: :room_id
    belongs_to :user, Dutchpay.Accounts.User, foreign_key: :user_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end
