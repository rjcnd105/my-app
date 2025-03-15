defmodule DeopjibWeb.HtmlHelper do
  def render_if_ok(result) do
    case result do
      {:ok, msg} -> msg
      _ -> nil
    end
  end
end
