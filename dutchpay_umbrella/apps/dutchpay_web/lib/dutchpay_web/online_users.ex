defmodule DutchpayWeb.OnlineUsers do
  @topic "online_users"

  def topic, do: @topic

  def list() do
    @topic
    # list()까지만 하면 데이터 구조는 아래와 같음
    # %{
    #  "1" => %{
    #    metas: [%{phx_ref: "GCYirBlSOVHJDgdF"}, %{phx_ref: "GCYirCVFyXDJDsgB"}]
    #  },
    #  "9" => %{metas: [%{phx_ref: "GCYirBlYV0bJDgeF"}]}
    # }
    |> DutchpayWeb.Presence.list()
    |> Enum.into(
      %{},
      fn {id, %{metas: metas}} ->
        {String.to_integer(id), length(metas)}
      end
    )
  end

  # Presence 시스템에 해당 토픽으로 트리거 역할을 하게끔 함.
  # 이는 handle_event(%{event: "presence_diff"})로 받을 수 있다.
  # presence_diff
  def track(pid, user) do
    {:ok, _} = DutchpayWeb.Presence.track(pid, @topic, user.id, %{})
  end

  def online?(online_users, user_id) do
    Map.get(online_users, user_id, 0) > 0
  end

  def subscribe() do
    # LiveView 프로세서가 @topic을 구독하게 함
    Phoenix.PubSub.subscribe(Dutchpay.PubSub, @topic)
  end

  def update(online_users, %{joins: joins, leaves: leaves}) do
    IO.inspect(%{joins: joins, leaves: leaves}, label: "join, leaves")

    online_users
    |> process_updates(joins, &Kernel.+/2)
    |> process_updates(leaves, &Kernel.-/2)
  end

  defp process_updates(online_users, updates, operation) do
    Enum.reduce(updates, online_users, fn {id, %{metas: metas}}, acc ->
      Map.update(
        acc,
        String.to_integer(id),
        length(metas),
        &operation.(&1, length(metas))
      )
    end)
  end
end
