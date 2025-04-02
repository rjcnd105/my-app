defmodule Deopjib.Settlement.PayItemExcludedPayer do
  use Ash.Resource,
    otp_app: :deopjib,
    domain: Deopjib.Settlement,
    data_layer: AshPostgres.DataLayer

  alias Deopjib.Settlement.{Payer, PayItem}

  postgres do
    table("pay_item_excluded_payers")
    repo(Deopjib.Repo)

    references do
      reference(:payer, on_delete: :restrict)
      reference(:pay_item, on_delete: :restrict)
    end
  end

  relationships do
    belongs_to(:pay_item, PayItem, primary_key?: true, allow_nil?: false)
    belongs_to(:payer, Payer, primary_key?: true, allow_nil?: false)
  end

  actions do
    defaults([:create, :read, :destroy])
  end
end
