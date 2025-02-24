defmodule Deopjib.Secrets do
  use AshAuthentication.Secret

  def secret_for([:authentication, :tokens, :signing_secret], Deopjib.Accounts.User, _opts) do
    Application.fetch_env(:deopjib, :token_signing_secret)
  end
end
