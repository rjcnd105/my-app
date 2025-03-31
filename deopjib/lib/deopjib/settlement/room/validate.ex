defmodule Deopjib.Settlement.Room.Validate do
  alias Monad.Result, as: R
  alias DeopjibUtils.Debug

  defmodule MinMaxPayerInRoom do
    use Ash.Resource.Validation

    @impl true
    def validate(changeset, _opts, _context) do
      changeset
      |> R.ok()
      |> R.map_ok_nil_to_err(&Ash.Changeset.get_argument(&1, :payers))
      |> R.map(&IO.inspect(&1, label: "MaxPayerInRoom"))
      |> R.unwrap(fn payers ->
        count = Enum.count(payers)

        cond do
          count > 10 ->
            {:error, "최대 인원에 도달했어"}

          count == 0 ->
            {:error, "최소 1명은 필요해"}

          true ->
            :ok
        end
      end)
      |> IO.inspect(label: "MinMaxPayerInRoom")
    end
  end

  defmodule PayerUniqueNameInRoom do
    use Ash.Resource.Validation

    @impl true
    def validate(changeset, _opts, _context) do
      changeset
      |> R.ok()
      |> R.map_ok_nil_to_err(&Ash.Changeset.get_argument(&1, :payers))
      |> R.unwrap(fn payers ->
        # payers |> Debug.dbg_store()
        is_unique = DeopjibUtils.Enum.unique_by?(payers, & &1.name)

        if is_unique do
          :ok
        else
          R.err("이미 같은 이름이 있어")
        end
      end)
      |> IO.inspect(label: "PayerUniqueNameInRoom")
    end
  end
end
