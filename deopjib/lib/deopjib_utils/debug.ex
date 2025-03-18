:ets.new(:debug_values, [:named_table, :set, :public])

defmodule DeopjibUtils.Debug do
  def dbg_store(expression, name \\ :last_value) do
    result = expression

    dbg(expression)
    # 결과를 저장 (여러 방법 중 선택)
    :persistent_term.put({__MODULE__, name}, result)
    # 또는 Process.put(name, result) 사용

    # 원래 값 반환
    result
  end

  def dbg_vget(name \\ :last_value) do
    :persistent_term.get({__MODULE__, name}, nil)
  end
end
