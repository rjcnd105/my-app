defmodule Dutchpay.Repo.Migrations.CreateRoomMembership do
  use Ecto.Migration

  def change do
    create table(:room_membership) do
      # 유저나 룸이 삭제된다면 참조된 모든 :room_membership 제거
      add(:user_id, references(:users, on_delete: :delete_all), null: false)
      add(:room_id, references(:rooms, on_delete: :delete_all), null: false)

      timestamps(type: :utc_datetime)
    end

    create(index(:room_membership, [:user_id]))
    create(index(:room_membership, [:room_id]))
    create(unique_index(:room_membership, [:user_id, :room_id]))
  end
end
