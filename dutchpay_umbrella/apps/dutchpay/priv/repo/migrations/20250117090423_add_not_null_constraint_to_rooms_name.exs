defmodule Dutchpay.Repo.Migrations.AddNotNullConstraintToRoomsName do
  use Ecto.Migration

  def change do
    alter table(:rooms) do
      modify :name, :text, null: false
    end
  end
end
