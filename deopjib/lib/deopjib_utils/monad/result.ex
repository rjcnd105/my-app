defmodule Monad.Result do
  @type result_t(value, error) :: ok_t(value) | error_t(error)
  @type ok_t(a) :: {:ok, a}
  @type error_t(a) :: {:error, a}

  @spec map(result_t(v, e), (v -> b)) :: result_t(b, e) when v: term(), b: term(), e: term()
  def map({:ok, val}, f), do: {:ok, f.(val)}
  def map({:error, _val} = err, _f), do: err

  @spec map_err(result_t(any(), a), (a -> b)) :: result_t(any(), b) when a: term(), b: term()
  def map_err({:error, value}, f), do: {:error, f.(value)}
  def map_err({:ok, _} = result, _f), do: result

  @spec flat_map(result_t(a, e), (a -> result_t(b, e))) :: result_t(b, e)
        when a: term(), b: term(), e: term()
  def flat_map({:ok, val}, f) do
    case(f.(val)) do
      {:ok, _} = result ->
        result

      {:error, _} = result ->
        result

      other ->
        raise ArgumentError,
              "Expected function to return result_t type ({:ok, value} or {:error, reason}), got: #{inspect(other)}"
    end
  end

  def flat_map({:error, _val} = err, _f), do: err

  @spec match(result_t(v, e), %{ok: (v -> b), error: (e -> c)}) :: b | c
        when v: term(), e: term(), b: term(), c: term()
  def match({:ok, val}, %{ok: ok_fn, error: _err_fn}), do: ok_fn.(val)
  def match({:error, val}, %{ok: _ok_fn, error: err_fn}), do: err_fn.(val)

  @spec ok(a) :: ok_t(a) when a: term()
  def ok(val), do: {:ok, val}

  @spec ok?(result_t(any(), any())) :: boolean()
  def ok?({:ok, _val}), do: true
  def ok?({:error, _val}), do: false

  @spec err(a) :: error_t(a) when a: term()
  def err(val), do: {:error, val}

  @spec with_default(result_t(a, any()), b) :: a | b when a: term(), b: term()
  def with_default({:ok, value}, _default), do: value
  def with_default({:error, _}, default), do: default

  @spec err?(result_t(any(), any())) :: boolean()
  def err?({:error, _val}), do: true
  def err?({:ok, _val}), do: false

  @spec fold([result_t(v, e)]) :: result_t([v], e) when v: term(), e: term()
  def fold(list), do: fold(list, [])
  defp fold([{:ok, v} | tail], acc), do: fold(tail, [v | acc])
  defp fold([{:error, v} | _tail], _acc), do: {:error, v}
  defp fold([], acc), do: {:ok, Enum.reverse(acc)}

  @spec from_option(ok_t(v) | :error) :: result_t(v, nil) when v: term()
  def from_option(result), do: from_option(result, nil)

  @spec from_option(ok_t(v) | :error, d) :: result_t(v, d)
        when v: term(), d: term()
  def from_option({:ok, val}, _default), do: {:ok, val}
  def from_option(:error, default), do: err(default)

  @spec unwrap({:ok, v}, dv) :: v | dv when v: term(), dv: term()
  def unwrap({:ok, value}, _default), do: value
  def unwrap(_, default), do: default

  @spec from_nil(nil | v, e) :: {:ok, v} | {:error, nil | e} when v: term(), e: term()
  def from_nil(nil, error_value), do: {:error, error_value}
  def from_nil(value, _error_value), do: {:ok, value}
end
