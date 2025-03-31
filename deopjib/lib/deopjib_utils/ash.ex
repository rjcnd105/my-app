defmodule DeopjibUtils.Ash do
  alias Monad.Result, as: R

  defmodule HTML do
    @spec as_changeset(Phoenix.HTML.Form.t()) :: R.result_t(Ash.Changeset.t(), :string)
    def as_changeset(%Phoenix.HTML.Form{} = form) do
      Monad.Result.from_with_default(
        DeopjibUtils.Map.get_nested(form, [:source, :source]),
        "changeset not found"
      )
    end
  end
end
