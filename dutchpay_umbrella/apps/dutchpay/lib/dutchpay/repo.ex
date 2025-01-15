defmodule Dutchpay.Repo do
  use Ecto.Repo,
    otp_app: :dutchpay,
    adapter: Ecto.Adapters.Postgres
end
