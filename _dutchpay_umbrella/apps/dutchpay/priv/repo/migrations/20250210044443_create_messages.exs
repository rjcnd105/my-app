defmodule Dutchpay.Repo.Migrations.CreateMessages do
  use Ecto.Migration

  def change do
    create table(:messages) do
      add :body, :text, null: false

      # 외래키
      # add :user_id, references(:users, on_delete: :nothing)
      # other options
      # :nilify_all - references 삭제시 nil
      # :restrict(alias :nothing) - 오류가 발생하여 메세지에 조치를 취할때까지 references를 삭제 못함
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :room_id, references(:rooms, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:messages, [:user_id])
    create index(:messages, [:room_id])
  end
end
