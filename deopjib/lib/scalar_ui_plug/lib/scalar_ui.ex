defmodule Scalar.Plug.ScalarUI do
  @moduledoc """
  A Plug for rendering Scalar UI.

  ## Usage

  If you're using Phoenix Framework, add Scalar UI by add this plug to the router:

  ```elixir
  scope "/api" do
    ...
    get "/scalarui", Scalar.Plug.ScalarUI, url: "/spec/openapi"
  end
  ```

  ## Options

  * `url` - The openapi path to fetch. Support both `yaml` and `json`.
  * `title` - The documentation HTML page title, default to `Scalar`.
  * `theme` - The scalar theme, default to `default`. @see https://github.com/scalar/scalar/blob/main/documentation/themes.md
  * `proxy_url` - proxy url
  """

  @behaviour Plug

  import Plug.Conn

  @index_html """
  <!doctype html>
  <html>
    <head>
      <title><%= title %></title>
      <meta charset="utf-8" />
      <meta
        name="viewport"
        content="width=device-width, initial-scale=1" />
    </head>

    <body>
      <div id="app"></div>
      <script
        id="api-reference"
        data-theme="<%= theme %>"

        <%= for {k, v} <- scalar_opts do %>
          data-<%= k %>="<%= v %>"
        <% end %>
      >
      </script>

      <script>

      </script>

      <script src="https://cdn.jsdelivr.net/npm/@scalar/api-reference"></script>
    </body>
  </html>
  """

  @scalar_options [
    :url,
    :title,
    :theme,
    :proxy_url
  ]

  @impl true
  def init(opts) do
    scalar_opts = encode_options(opts)
    url = Keyword.get(opts, :url)
    title = Keyword.get(opts, :title, "scalar")
    theme = Keyword.get(opts, :theme, "default")

    opts = Keyword.drop(scalar_opts, [:title, :theme])

    [scalar_opts: opts, url: url, title: title, theme: theme]
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
