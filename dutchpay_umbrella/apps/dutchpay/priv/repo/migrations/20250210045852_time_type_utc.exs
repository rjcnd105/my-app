defmodule Dutchpay.Repo.Migrations.TimeTypeUtc do
  use Ecto.Migration

  def change do
    alter table(:messages) do
      modify :inserted_at, :utc_datetime, from: :naive_datetime
      modify :updated_at, :utc_datetime, from: :naive_datetime
    end

    alter table(:rooms) do
      modify :inserted_at, :utc_datetime, from: :naive_datetime
      modify :updated_at, :utc_datetime, from: :naive_datetime
    end
  end
end
