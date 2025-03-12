defmodule DeopjibWeb.Live.RoomEntry do
  use DeopjibWeb, :live_view
  alias DeopjibWebUI.Templates.Main
  alias DeopjibWebUI.Parts.{InputBox}

  def render(assigns) do
    ~H"""
    <Main.render class="mt-8">
      <h2 class="text-title font-light mb-4">누구누구 정산할거야?</h2>
      <InputBox.render id="name-input" theme={:big_rounded_border} placeholder="정산할 사람 이름" phx-key="name-input">
      <:bottom>
        <InputBox.message  />
      </:bottom>
      </InputBox.render>

    </Main.render>
    """
  end
end
