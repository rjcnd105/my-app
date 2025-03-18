defmodule Deopjib.Settlement.Payer do
  use Ash.Resource,
    otp_app: :deopjib,
    domain: Deopjib.Settlement,
    data_layer: AshPostgres.DataLayer

  @name_length [
    min: 1,
    max: 6
  ]
  postgres do
    table("payer")
    repo(Deopjib.Repo)

    references do
      reference(:room, on_delete: :delete)
    end
  end

  actions do
    defaults([:read, :destroy])

    create :create do
      accept([:name])
    end
  end

  attributes do
    uuid_primary_key(:id)

    attribute :name, :string do
      allow_nil?(false)
      public?(true)
    end

    create_timestamp(:inserted_at)
  end

  relationships do
    belongs_to(:room, Deopjib.Settlement.Room) do
      source_attribute(:room_id)
      destination_attribute(:id)
    end

    has_many(:settled_items, Deopjib.Settlement.PayItem) do
      source_attribute(:id)
      destination_attribute(:settled_ids)
    end
  end

  validations do
    validate(string_length(:name, max: 6), message: "이름은 6자까지 입력 가능해")
  end

  identities do
    identity(:unique_name_per_room, [:name, :room_id], message: "이미 방에 있는 이름이야")
  end

  def name_length, do: @name_length
end
