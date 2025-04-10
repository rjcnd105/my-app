defmodule Deopjib.Settlement.Room do
  use Ash.Resource,
    otp_app: :deopjib,
    domain: Deopjib.Settlement,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource]

  alias Deopjib.Settlement.Room.ShortId
  alias Deopjib.Settlement

  @max_payer 10
  @add_expiration_at 30
  @default_name "정산영수증"

  json_api do
    type("room")

    routes do
      base("rooms")

      get(:by_id, route: "/by_id/:id")
      get(:by_short_id, route: "/by_short_id/:short_id")
    end
  end

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
    defaults([:destroy])

    read :read do
      primary?(true)
    end

    read :by_id do
      get_by(:id)
    end

    create :create do
      accept([:name])
      primary?(true)
    end

    read :by_short_id do
      get_by(:short_id)
    end

    create :upsert_with_payers do
      upsert?(true)
      upsert_identity(true)
      argument(:id, :uuid, allow_nil?: true)
      argument(:payers, {:array, :map})

      change(set_attribute(:name, @default_name))
      change(manage_relationship(:payers, type: :create))
    end

    update :update_name do
      accept([:name])
      require_atomic?(false)
    end

    update :put_payers_in_room do
      argument(:payers, {:array, :map})
      require_atomic?(false)

      change(manage_relationship(:payers, type: :direct_control))
    end
  end

  changes do
    alias Deopjib.Settlement.Room.Change
    change(Change.SetExpirationAt, on: :create)
    change(set_new_attribute(:short_id, &ShortId.generate/0), on: :create)
  end

  validations do
    alias Deopjib.Settlement.Room.Validate

    validate(string_length(:name, min: 1, max: 13))
    validate(Validate.MinMaxPayerInRoom, where: [action_is(:upsert_with_payers)])
    validate(Validate.PayerUniqueNameInRoom, where: [action_is(:upsert_with_payers)])
  end

  attributes do
    uuid_primary_key(:id)

    attribute :short_id, :string do
      allow_nil?(true)
      public?(true)
    end

    attribute :name, :string do
      allow_nil?(false)
      public?(true)
      constraints(max_length: 8, min_length: 1, allow_empty?: false)
    end

    attribute :expiration_at, :utc_datetime do
      allow_nil?(true)
      public?(true)
    end

    create_timestamp(:inserted_at)
    update_timestamp(:updated_at)
  end

  relationships do
    has_many :payers, Deopjib.Settlement.Payer do
      source_attribute(:id)
      destination_attribute(:room_id)
      public?(true)
    end
  end

  aggregates do
    count :counts_of_payers, :payers do
      public?(true)
    end
  end

  def max_payer(), do: @max_payer
  def add_expiration_at(), do: @add_expiration_at

  defmodule ShortId do
    use Puid, total: 1.0e12, risk: 1.0e15
  end

  identities do
    identity(:unique_short_id, keys: [:short_id])
  end
end
