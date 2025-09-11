defmodule Deopjib.Secrets do
  use AshAuthentication.Secret

  @spec secret_for(
          [:authentication | :signing_secret | :tokens, ...],
          Deopjib.Accounts.User,
          any(),
          any()
        ) :: :error | {:ok, any()}
  def secret_for([:authentication, :tokens, :signing_secret], Deopjib.Accounts.User, _opts, _context) do
    Application.fetch_env(:deopjib, :token_signing_secret)
  end
end
