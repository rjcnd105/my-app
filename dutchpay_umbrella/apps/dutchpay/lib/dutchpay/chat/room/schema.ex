defmodule Dutchpay.Chat.Room.Schema do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  schema "rooms" do
    field(:name, :string)
    field(:topic, :string)

    # 일대다인 경우에 연결된 다수를 가져옴
    has_many(:messages, Dutchpay.Chat.Message.Schema, foreign_key: :room_id)

    timestamps(type: :utc_datetime)
  end

  @doc false
  # 제약 조건 추가
  def changeset(room, attrs) do
    room
    |> cast(attrs, [:name, :topic])
    |> validate_required(:name, message: "방 이름을 입력해주세요.")
    |> validate_length(:name, min: 3, max: 80, message: "최소 3자, 최대 80자 입력가능합니다")
    |> validate_format(:name, ~r/\A[ㄱ-ㅎA-z0-9-_]+\z/, message: "한글, 영문, 숫자, -, _만 포함할 수 있습니다.")
    |> validate_length(:topic, max: 200, message: "최대 200자까지 입력 가능합니다.")
    # unique_constraint는 db 삽입시 확인되므로, 그 전에 validate에러가 발생시에는 고유한지 아닌지 알 수 없다.
    # unsafe_validate_unique는 거의 동시에 발생하는 unique 제약은 검증할 수 없지만
    # 유저에게 정보를 주기 위한 validate 시점의 unique 검증을 한다.
    |> unsafe_validate_unique(:name, Dutchpay.Repo, message: "이미 같은 방 이름이 있습니다.")
    # unique_constraint 제약사항이 없어도 db 제약이 있기 때문에 유니크 값이 들어가지는 않지만
    # 500 에러가 뜨며 터지기 때문에 필요하다
    |> unique_constraint(:name, message: "이미 같은 방 이름이 있습니다.")
  end
end
