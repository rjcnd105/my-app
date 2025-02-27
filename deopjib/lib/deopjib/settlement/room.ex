defmodule Deopjib.Settlement.Room do
  use Ash.Resource,
    otp_app: :deopjib,
    domain: Deopjib.Settlement,
    data_layer: AshPostgres.DataLayer

  postgres do
    table("rooms")
    repo(Deopjib.Repo)
  end

  code_interface do
    define(:create, action: :create)
    define(:read)
    define(:destroy)
  end

  actions do
    defaults([:read, :destroy])

    create :create do
      accept([:name])

      change(fn changeset, _context ->
        expiration_at = DateTime.utc_now() |> DateTime.add(7, :day)

        changeset
        |> Ash.Changeset.force_change_attribute(:expiration_at, expiration_at)
      end)
    end
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

  relationships do
    has_many(:payers, Deopjib.Settlement.Payer) do
      source_attribute(:id)
      destination_attribute(:room_id)
    end
  end

  validations do
    validate(string_length(:name, min: 1, max: 13))
  end
end
