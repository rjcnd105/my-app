defmodule Deopjib.Settlement do
  use Ash.Domain, otp_app: :deopjib, extensions: [AshJsonApi.Domain, AshAdmin.Domain]

  alias Deopjib.Settlement.{Room, Payer, PayItem, PayItemExcludedPayer}

  admin do
    show?(true)
  end

  json_api do
    routes do
      base_route("rooms", Room) do
        index(:read)
        related(:payers, :read)
      end
    end
  end



  resources do
    resource Room do
      # define :create_room, action: :create
      # define :upsert_room_with_payers, action: :upsert_with_payers
      # define :get_room_by_id, action: :read, get_by: :id
      # define :get_room_by_short_id, action: :read, get_by: :short_id

      # define :delete_room, action: :destroy
    end

    resource Payer do
      # define :create_payer, action: :create, args: [:name]
      # define :get_payer_by_id, action: :read, get_by: :id
      # define :delete_payer, action: :destroy
    end

    resource PayItem do
      # define :create_pay_item, action: :create
      # define :get_pay_item_by_id, action: :read, get_by: :id
      # define :delete_pay_item, action: :destroy
      # # define (:get_pay_items_from_payer_id, )
      # define :create_pay_item_from_words, action: :upsert_from_words
    end

    resource PayItemExcludedPayer do
      # define :get_pay_item_excluded_payer, action: :read
      # define :delete_pay_item_excluded_payer, action: :destroy
    end
  end
end
