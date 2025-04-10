defmodule DeopjibWeb.AshJsonApiRouter do
  use AshJsonApi.Router,
    domains: [Module.concat(["Deopjib.Settlement"])],
    json_schema: "/json_schema",
    open_api: "/open_api",
    open_api_title: "Deopjib API Documentation"
end
