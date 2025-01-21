defmodule Dutchpay.Chat.Room.Schema do
  @moduledoc false
  use Ecto.Schema

  import Ecto.Changeset

  schema "rooms" do
    field :name, :string
    field :topic, :string

    timestamps()
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
  end
end
