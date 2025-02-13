# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Dutchpay.Repo.insert!(%Dutchpay.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#
# mix run priv/repo/seeds.exs
alias Dutchpay.Accounts
alias Dutchpay.Chat.{Room, Message}
alias Dutchpay.Repo

defmodule UserNames do
  @enforce_keys [:red, :blue, :black]
  defstruct red: "red", blue: "blue", black: "black"
end

names = [
  "hoejun",
  "suhyun",
  "hanul",
  "hyeeun",
  "seunghoon"
]

pw = "dutchpay1234"
seed_email = "@dutchpay.me"

Repo.transaction(fn ->
  users =
    for name <- names do
      email = (name |> String.downcase()) <> seed_email

      with {:ok, user} <-
             Accounts.register_user(%{email: email, password: pw, password_confirmation: pw}) do
        user
      else
        {:error, reason} ->
          raise "User registration failed for #{email}: #{inspect(reason)}"
      end
    end

  [hoejun, suhyun, hanul, hyeeun | _] = users

  room = Dutchpay.Repo.insert!(%Dutchpay.Chat.Room.Schema{name: "seed-room", topic: "first seed"})

  seed_messages = [
    {hoejun, "다들 잘 지내시나요"},
    {suhyun, "그럼요 하하"},
    {hyeeun, "다들 오랫만이에요"},
    {hanul, "..."},
    {hoejun, "hanul씨 말 좀 해보세요"}
  ]

  IO.inspect(room, label: "room")

  for {user, message} <- seed_messages do
    IO.inspect(user, label: "user")

    Repo.insert!(%Dutchpay.Chat.Message.Schema{
      user: user,
      room: room,
      body: message
    })
  end
end)
