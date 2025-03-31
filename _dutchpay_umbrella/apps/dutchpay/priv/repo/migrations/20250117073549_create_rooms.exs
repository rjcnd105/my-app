defmodule Dutchpay.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :text, null: false
      add :topic, :text

      timestamps()
    end
  end
end
