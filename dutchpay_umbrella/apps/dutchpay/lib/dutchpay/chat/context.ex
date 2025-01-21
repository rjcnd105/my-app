defmodule Dutchpay.Chat do
  @moduledoc false
  alias Dutchpay.Chat.Room.Schema
  alias Dutchpay.Repo

  @doc false
  def list_rooms do
    Repo.all(Schema)
  end
end
