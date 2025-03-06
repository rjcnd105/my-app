defmodule DeopjibWeb.Live.RoomEntry do
  use DeopjibWeb, :live_view

  def render(assigns) do
    ~H"""
    <div>
      <h1>Room Entry</h1>
      <p>Welcome to the room entry page.</p>
    </div>
    """
  end
end
