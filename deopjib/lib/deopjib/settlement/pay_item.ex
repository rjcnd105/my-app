defmodule Deopjib.Settlement.PayItem do
  use Ash.Resource,
    otp_app: :deopjib,
    domain: Deopjib.Settlement,
    data_layer: AshPostgres.DataLayer

  postgres do
    table("pay_item")
    repo(Deopjib.Repo)

    references do
      reference(:settler, on_delete: :delete)
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
      allow_nil?(true)
      public?(true)
    end

    attribute :price, :integer do
      allow_nil?(true)
      public?(true)
    end

    create_timestamp(:inserted_at)
  end

  relationships do
    belongs_to(:room, Deopjib.Settlement.Room) do
      source_attribute(:room_id)
      destination_attribute(:id)
    end

    belongs_to(:settler, Deopjib.Settlement.Payer) do
      source_attribute(:settled_ids)
      destination_attribute(:id)
      allow_nil?(false)
    end

    has_many(:excluded_payers, Deopjib.Settlement.Payer) do
      source_attribute(:excluded_payer_ids)
      destination_attribute(:id)
    end
  end

  validations do
    validate(string_length(:name, min: 1, max: 13))
  end
end
