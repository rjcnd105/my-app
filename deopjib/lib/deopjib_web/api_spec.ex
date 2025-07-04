defmodule DeopjibWeb.ApiSpec do
  alias Oaskit.Spec.Paths
  alias Oaskit.Spec.Server
  use Oaskit

  @impl true
  def spec do
    %{
      openapi: "3.1.1",
      info: %{
        title: "Deopjib Api",
        version: "1.0.0",
        description: "Main HTTP API for My App"
      },
      servers: [Server.from_config(:my_app, Deopjib.Endpoint)],
      paths:
        Paths.from_router(Deopjib.Router, filter: &String.starts_with?(&1.path, "/api/json/"))
    }
  end
end
