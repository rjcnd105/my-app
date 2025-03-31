defmodule DeopjibUtils.Enum do
  @doc """
  주어진 열거 가능한 컬렉션의 각 요소에 대해 fun을 적용한 결과가 모두 유일한지 검사합니다.
  중복된 결과가 발견되는 즉시 false를 반환하여 성능을 최적화합니다.

  ## 예시

      iex> Utils.unique_by?([1, 2, 3], fn x -> x end)
      true

      iex> Utils.unique_by?([1, 2, 1], fn x -> x end)
      false
  """
  @spec unique_by?(Enumerable.t(), (any() -> any())) :: boolean()
  def unique_by?(enum, fun) do
    # reduce_while이 false로 중단되지 않았다면 모든 결과가 고유함
    Enum.reduce_while(enum, MapSet.new(), fn item, acc ->
      result = fun.(item)

      if MapSet.member?(acc, result) do
        # 중복된 결과를 발견하면 즉시 false 반환
        {:halt, false}
      else
        # 새로운 결과는 집합에 추가
        {:cont, MapSet.put(acc, result)}
      end
    end) != false
  end
end
