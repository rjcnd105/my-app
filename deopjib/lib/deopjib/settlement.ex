defmodule Deopjib.Settlement do
  use Ash.Domain, otp_app: :deopjib, extensions: [AshAdmin.Domain]

  admin do
    show?(true)
  end

  resources do
    resource Deopjib.Settlement.Room do
      define(:create_room, action: :create)
      define(:get_room, action: :read)
      define(:delete_room, action: :destroy)
    end

    resource Deopjib.Settlement.Payer do
      define(:create_payer, action: :create)
      define(:get_payer, action: :read)
      define(:delete_payer, action: :destroy)
    end

    resource Deopjib.Settlement.PayItem do
      define(:create_pay_item, action: :create)
      define(:get_pay_item, action: :read)
      define(:delete_pay_item, action: :destroy)
    end
  end
end
