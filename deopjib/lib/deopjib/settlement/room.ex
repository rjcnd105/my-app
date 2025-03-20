defmodule Deopjib.Settlement.Room do
  use Ash.Resource,
    otp_app: :deopjib,
    domain: Deopjib.Settlement,
    data_layer: AshPostgres.DataLayer

  @max_payer 10
  @add_expiration_at 30
  @default_name "정산영수증"

  postgres do
    table("rooms")
    repo(Deopjib.Repo)
  end

  # code_interface do
  #   define(:create, action: :create)
  #   define(:read)
  #   define(:destroy)
  # end

  actions do
    defaults([:read, :destroy])

    create :create do
      accept([:name])
      primary?(true)
    end

    create :create_with_payers do
      argument(:payers, {:array, :map})

      change(set_attribute(:name, @default_name))
      change(manage_relationship(:payers, type: :create))
    end

    update :put_payers_in_room do
      argument(:payers, {:array, :map})
      require_atomic?(false)

      change(manage_relationship(:payers, type: :direct_control))
    end
  end

  changes do
    change(Deopjib.Settlement.Room.Changes.SetExpirationAt, on: :create)
  end

  attributes do
    uuid_primary_key(:id)

    attribute(:name, :string) do
      allow_nil?(false)
      public?(true)
    end

    attribute(:expiration_at, :utc_datetime) do
      allow_nil?(true)
      public?(true)
    end

    create_timestamp(:inserted_at)
    update_timestamp(:updated_at)
  end

  aggregates do
    count(:counts_of_payers, :payers) do
      public?(true)
    end
  end

  relationships do
    has_many(:payers, Deopjib.Settlement.Payer) do
      source_attribute(:id)
      destination_attribute(:room_id)
    end
  end

  validations do
    validate(string_length(:name, min: 1, max: 13))
  end

  def max_payer(), do: @max_payer
  def add_expiration_at(), do: @add_expiration_at
end
