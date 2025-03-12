defmodule DeopjibWeb.TestController do
  use DeopjibWeb, :controller

  def index(conn, params) do
    json(conn, %{params: params})
  end

  def hello(conn, _params) do
    json(conn, %{message: "Hello, World!"})
  end
end
