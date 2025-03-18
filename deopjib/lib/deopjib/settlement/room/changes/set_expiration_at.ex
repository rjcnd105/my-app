defmodule Deopjib.Settlement.Room.Changes.SetExpirationAt do
  use Ash.Resource.Change

  @impl true
  def change(changeset, _opts, _context) do
    expiration_at = DateTime.utc_now() |> DateTime.add(7, :day)

    changeset
    |> Ash.Changeset.force_change_attribute(:expiration_at, expiration_at)
  end
end
