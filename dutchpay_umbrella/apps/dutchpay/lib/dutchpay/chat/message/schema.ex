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
    # 사용자의 입력에서 사용자 및 방 id를 가져온다면 보안에 문제가 될 수 있기 때문에
    # cast를 써서 :body를 제외한 나머지를 무시한다.
    # 해커는 내가 정의한 이벤트와 상관없이 원하는 임의의 데이터를 전송할 수 있음을 명시해라.
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end
