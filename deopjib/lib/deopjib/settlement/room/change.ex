defmodule Deopjib.Settlement.Room.Change do
  alias Deopjib.Settlement.Room

  defmodule SetExpirationAt do
    use Ash.Resource.Change

    @impl true
    def change(changeset, _opts, _context) do
      expiration_at =
        DateTime.utc_now()
        |> DateTime.add(Room.add_expiration_at(), :day)

      changeset
      |> Ash.Changeset.force_change_attribute(:expiration_at, expiration_at)
    end
  end
end
