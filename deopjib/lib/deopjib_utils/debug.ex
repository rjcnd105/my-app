:ets.new(:debug_values, [:named_table, :set, :public])

if Mix.env() in [:dev, :test] do
  defmodule DeopjibUtils.Debug do
    def dbg_store(expression, name \\ :last_value, opts \\ []) do
      result = expression

      if(opts[:print]) do
        dbg(expression)
      end

      :persistent_term.put({__MODULE__, name}, result)

      result
    end

    def dbg_vget(name \\ :last_value) do
      :persistent_term.get({__MODULE__, name}, nil)
    end
  end
else
  defmodule DeopjibUtils.Debug do
    # 프로덕션용 더미 함수
    def dbg_store(expression, _name \\ nil, _opts \\ []), do: expression
    def dbg_vget(_name \\ nil), do: nil
  end
end
