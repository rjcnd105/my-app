defmodule Scalar.Plug.ScalarUI do
  @moduledoc """
  A Plug for rendering Redoc UI.

  ## Usage

  If you're using Phoenix Framework, add Redoc UI by add this plug to the router:

  ```elixir
  scope "/api" do
    ...
    get "/redoc", Redoc.Plug.RedocUI, spec_url: "/spec/openapi"
  end
  ```

  ## Options

  * `spec_url` - The openapi path to fetch. Support both `yaml` and `json`.
  * `redoc_version` - Specify a Redoc version, default to `latest`.
  * `title` - The documentation HTML page title, default to `ReDoc`.
  """

  @behaviour Plug

  import Plug.Conn

  # @index_html """
  # <!doctype html>
  # <html>
  #   <head>
  #     <title><%= title %></title
  #     <meta charset="utf-8">
  #     <meta name="viewport" content="width=device-width, initial-scale=1">
  #     <link href="https://fonts.googleapis.com/css?family=Montserrat:300,400,700|Roboto:300,400,700" rel="stylesheet">

  #     <style>
  #       body {
  #         margin: 0;
  #         padding: 0;
  #       }
  #     </style>
  #   </head>
  #   <body>
  #     <redoc
  #       <%= for {k, v} <- redoc_opts do %>
  #        <%= k %>="<%= v %>"
  #       <% end %>
  #     ></redoc>
  #     <script src="https://cdn.jsdelivr.net/npm/redoc@<%= Plug.HTML.html_escape(redoc_version) %>/bundles/redoc.standalone.js"></script>
  #   </body>
  # </html>
  # """
  @index_html """
  <!doctype html>
  <html>
    <head>
      <title><%= scalar_opts[:title] %></title>
      <meta charset="utf-8" />
      <meta
        name="viewport"
        content="width=device-width, initial-scale=1" />
    </head>

    <body>
      <div id="app"></div>
      <script
        id="api-reference"
        data-url="<%= url %>"
        data-theme="<%= theme %>"
      >
      </script>

      <script>
      <%= for {k, v} <- scalar_opts do %>
        <%= k %>="<%= v %>"
      <% end %>
      </script>

      <script src="https://cdn.jsdelivr.net/npm/@scalar/api-reference"></script>
    </body>
  </html>
  """

  @scalar_options [
    :url,
    :title,
    :theme
  ]

  @impl true
  def init(opts) do
    scalar_opts = encode_options(opts)
    url = Keyword.get(opts, :url)
    title = Keyword.get(opts, :title, "scalar")
    theme = Keyword.get(opts, :theme, "default")

    [scalar_opts: scalar_opts, url: url, title: title, theme: theme]
  end

  @impl true
  def call(conn, opts) do
    conn
    |> put_resp_content_type("text/html")
    |> send_resp(200, EEx.eval_string(@index_html, opts))
  end

  defp encode_options(opts) do
    Keyword.take(opts, @scalar_options)
    |> Enum.map(fn {key, value} -> {to_kebab_case(key), value} end)
  end

  defp to_kebab_case(identifier) do
    identifier
    |> to_string()
    |> String.replace("_", "-")
  end
end
