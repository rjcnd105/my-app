defmodule Deopjib.Settlement.PayItem.Change do
  alias Monad.Result, as: R
  alias Deopjib.Settlement.PayItem

  defmodule InputFromWords do
    use Ash.Resource.Change

    @impl true
    def change(changeset, _opts, _context) do
      changeset
      |> Ash.Changeset.before_transaction(&words_split_to_new_attributes/1)
    end

    defp words_split_to_new_attributes(changeset) do
      words = Ash.Changeset.get_argument(changeset, :words)

      with [name, amount] <- String.split(words, "/", trim: true),
           num_amount <- String.to_integer(String.replace(amount, ",", "")) do
        changeset
        |> Ash.Changeset.change_new_attribute(:name, name)
        |> Ash.Changeset.change_new_attribute(:amount, num_amount)
      else
        _ ->
          invalid_error =
            Ash.Error.Changes.InvalidArgument.exception(
              field: :words,
              message: "item/14,000 You must enter in the same format.",
              value: words
            )

          changeset
          |> Ash.Changeset.add_error(invalid_error)
      end
    end
  end
end
