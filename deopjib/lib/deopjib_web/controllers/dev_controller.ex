defmodule DeopjibWeb.DevController do
  use DeopjibWeb, :controller
  plug(:accepts, ["json"])

  def envs(conn, _params) do
    Application.get_all_env()
  end
end
