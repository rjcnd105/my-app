defmodule Deopjib.Settlement.PayItem do
  use Ash.Resource,
    otp_app: :deopjib,
    domain: Deopjib.Settlement,
    data_layer: AshPostgres.DataLayer

  alias Deopjib.Settlement.{Room, Payer}

  postgres do
    table("pay_item")
    repo(Deopjib.Repo)

    references do
      reference(:settler, on_delete: :restrict)
      reference(:room, on_delete: :restrict)
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
    belongs_to(:room, Room) do
      source_attribute(:room_id)
      destination_attribute(:id)
    end

    belongs_to(:settler, Payer) do
      source_attribute(:settled_ids)
      destination_attribute(:id)
      allow_nil?(false)
    end

    many_to_many(:excluded_payers, Payer) do
      through(Deopjib.Settlement.PayItemExcludedPayer)
      source_attribute_on_join_resource(:payer_id)
      destination_attribute_on_join_resource(:pay_item_id)
    end
  end

  validations do
    validate(
      string_length(:name, min: 1, max: 13, message: "Name must be between 1 and 13 characters")
    )
  end
end
