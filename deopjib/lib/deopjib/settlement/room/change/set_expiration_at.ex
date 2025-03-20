defmodule Deopjib.Settlement.Room.Changes.SetExpirationAt do
  use Ash.Resource.Change
  alias Deopjib.Settlement.Room

  @impl true
  def change(changeset, _opts, _context) do
    expiration_at =
      DateTime.utc_now()
      |> DateTime.add(Room.add_expiration_at(), :day)

    changeset
    |> Ash.Changeset.force_change_attribute(:expiration_at, expiration_at)
  end
end
