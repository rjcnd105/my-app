defmodule Deopjib.Settlement.Room.Validate.MaxPayerInRoom do
  use Ash.Resource.Validation

  @impl true
  def validate(changeset, _opts, _context) do
    changeset =
      changeset
      |> DeopjibUtils.Ash.HTML.as_changeset()
  end
end
