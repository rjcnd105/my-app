defmodule DeopjibWeb.AshJsonApiRouter do
  use AshJsonApi.Router,
    domains: [Module.concat(["Deopjib.Settlement"])],
    open_api: "/open_api"
end
