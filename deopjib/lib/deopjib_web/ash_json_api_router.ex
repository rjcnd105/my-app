defmodule DeopjibWeb.AshJsonApiRouter do
  open_api_file =
    if Mix.env() == :prod do
      "priv/static/open_api.json"
    else
      nil
    end

  use AshJsonApi.Router,
    domains: [Module.concat(["Deopjib.Settlement"])],
    open_api: "/open_api",
    open_api_title: "Deopjib API Documentation",
    modify_open_api: {
      __MODULE__,
      :modify_open_api,
      []
    },
    json_schema: "/json_schema",
    open_api_file: open_api_file

  def modify_open_api(spec, conn, opts) do
    IO.inspect(spec, label: "spec")
    IO.inspect(conn, label: "conn")
    IO.inspect(opts, label: "opts")

    DeopjibUtils.Debug.dbg_store(spec)

    spec
  end

  # def modify_open_api(spec, _, _) do
  #   %{
  #     spec
  #     | info: %{
  #         spec.info
  #         | title: "MyApp Title JSON API",
  #           version: Application.spec(:my_app, :vsn) |> to_string()
  #       }
  #   }
  # end
end
