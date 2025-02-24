defmodule Dutchpay.Chat.RoomMembership.Schema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "room_membership" do
    belongs_to(:room, Dutchpay.Chat.Room.Schema)
    belongs_to(:user, Dutchpay.Accounts.User)

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(room_membership, attrs) do
    room_membership
    |> cast(attrs, [])
    |> validate_required([])
  end
end
