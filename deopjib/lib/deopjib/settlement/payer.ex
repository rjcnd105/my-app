defmodule Deopjib.Settlement.Payer do
  use Ash.Resource,
    otp_app: :deopjib,
    domain: Deopjib.Settlement,
    data_layer: AshPostgres.DataLayer

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
    validate(string_length(:name, min: 1, max: 6))
  end
end
