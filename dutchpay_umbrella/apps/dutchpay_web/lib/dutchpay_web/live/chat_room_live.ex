defmodule DutchpayWeb.ChatRoomLive do
  use DutchpayWeb, :live_view

  def render(assigns) do
    ~H"""
    <div>Welcome to the chat! {2 + 2}<% hidden %></div>
    """
  end
end
