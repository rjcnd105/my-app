defmodule Dutchpay.Chat do
  @moduledoc false
  import Ecto.Query

  alias Dutchpay.Chat.Room.Schema
  alias Dutchpay.Repo

  @doc false
  def list_rooms do
    Repo.all(from(Schema, order_by: [desc: :updated_at]))
  end
end
