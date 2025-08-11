defmodule DeopjibWeb.SyncController do
  use Phoenix.Controller, formats: [:html, :json]
  use Phoenix.Router

  import Elixir.Phoenix.Sync.Controller
  alias Deopjib.Settlement.{Room, Payer, PayItem}

  require Ash.Query

  def room_read(conn, _) do
    query = Room
    |> Ash.Query.for_read(:read)
    |> Ash.Query.data_layer_query()

    with {:ok, query} <- query do
      conn
      |> sync_render(query)
    else
      {:error, error} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: error})
    end

    conn
    |> sync_render(query)
  end
end
