defmodule Deopjib.Settlement do
  use Ash.Domain, otp_app: :deopjib, extensions: [AshAdmin.Domain, AshPhoenix]

  alias Deopjib.Settlement.{Room, Payer, PayItem, PayItemExcludedPayer}

  admin do
    show?(true)
  end

  resources do
    resource Room do
      define(:create_room, action: :create)
      define(:get_room, action: :read)
      define(:delete_room, action: :destroy)
    end

    resource Payer do
      define(:create_payer, action: :create, args: [:name])
      define(:get_payer, action: :read)
      define(:delete_payer, action: :destroy)
    end

    resource PayItem do
      define(:create_pay_item, action: :create)
      define(:get_pay_item, action: :read)
      define(:delete_pay_item, action: :destroy)
    end

    resource PayItemExcludedPayer do
      define(:get_pay_item_excluded_payer, action: :read)
      define(:delete_pay_item_excluded_payer, action: :destroy)
    end
  end
end
