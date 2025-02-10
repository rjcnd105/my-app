defmodule Dutchpay.Chat.Message.Schema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "messages" do
    field :user_id, :id
    field :room_id, :id
    field :body, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(message, attrs) do
    message
    |> cast(attrs, [:body])
    |> validate_required([:body])
  end
end
