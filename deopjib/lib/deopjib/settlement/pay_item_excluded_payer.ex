defmodule Deopjib.Settlement.PayItemExcludedPayer do
  use Ash.Resource,
    otp_app: :deopjib,
    domain: Deopjib.Settlement,
    data_layer: AshPostgres.DataLayer,
    extensions: [AshJsonApi.Resource]

  alias Deopjib.Settlement.{Payer, PayItem}

  json_api do
    type("pay_item_excluded_payer")
    includes([:pay_item, :payer])

    primary_key do
      keys([:pay_item_id, :payer_id])
      delimiter("-")
    end
  end

  postgres do
    table("pay_item_excluded_payers")
    repo(Deopjib.Repo)

    references do
      reference(:payer, on_delete: :restrict)
      reference(:pay_item, on_delete: :restrict)
    end
  end

  actions do
    defaults([:create, :read, :destroy])
  end

  relationships do
    belongs_to(:pay_item, PayItem) do
      primary_key?(true)
      allow_nil?(false)
      public?(true)
    end

    belongs_to(:payer, Payer) do
      primary_key?(true)
      allow_nil?(false)
      public?(true)
    end
  end
end
