defmodule Deopjib.Accounts do
  use Ash.Domain, otp_app: :deopjib, extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource Deopjib.Accounts.Token
    resource Deopjib.Accounts.User
  end
end
