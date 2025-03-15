defmodule DeopjibWeb.Utils.Error do
  alias Monad.Result, as: R

  @spec translate_first_error(list()) :: R.ok_t() | :error
  def translate_first_error(errors) do
    first_error = Enum.fetch(errors, 0)

    case first_error do
      {:ok, {msg, opts}} ->
        Gettext.dgettext(DeopjibWeb.Gettext, "errors", msg, opts)
        |> Monad.Result.ok()

      _ ->
        :error
    end
  end
end
