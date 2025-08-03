defmodule Deopjib.Settlement.Payer do
  use Ash.Resource,
    otp_app: :deopjib,
    domain: Deopjib.Settlement,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource]

  @name_length [
    min: 1,
    max: 6
  ]
  json_api do
    type "payer"

    includes [:room, :settled_items]

    routes do
      base "payers"

      index :read
    end
  end

  postgres do
    table "payer"
    repo Deopjib.Repo

    references do
      reference :room, on_delete: :restrict
    end
  end

  actions do
    defaults [:read, :destroy, :update]

    create :create do
      primary? true
      accept [:name]
    end
  end

  validations do
    validate string_length(:name, min: 1, max: 6), message: "이름은 6자까지 입력 가능해"
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
      public? true
    end

    attribute :banc_account, :string do
      public? true
      default ""
    end

    create_timestamp :inserted_at
  end

  relationships do
    belongs_to :room, Deopjib.Settlement.Room do
      source_attribute :room_id
      destination_attribute :id
      public? true
    end

    has_many :settled_items, Deopjib.Settlement.PayItem do
      source_attribute :id
      destination_attribute :settled_id
      public? true
    end
  end

  aggregates do
    sum :total_paid, :settled_items, :amount
  end

  def name_length, do: @name_length

  identities do
    identity :unique_name_per_room, [:name, :room_id], message: "이미 방에 있는 이름이야"
  end
end
