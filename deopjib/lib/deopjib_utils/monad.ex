defmodule Monad.Result do
  @type result_t(a) :: ok_t(a) | error_t(a)
  @type ok_t(a) :: {:ok, a}
  @type error_t(a) :: {:error, a}

  def map({:ok, val}, f), do: {:ok, f.(val)}
  def map({:error, _val} = err, _f), do: err

  @spec match(result_t(a), %{ok: (a -> b), error: (a -> c)}) :: b | c
        when a: term(), b: term(), c: term()

  def match({:ok, val}, %{ok: ok_fn, error: _err_fn}), do: ok_fn.(val)
  def match({:error, val}, %{ok: _ok_fn, error: err_fn}), do: err_fn.(val)

  def ok(val), do: {:ok, val}

  def ok?({:ok, _val}), do: true
  def ok?({:error, _val}), do: false

  def err(val), do: {:error, val}

  def err?({:error, _val}), do: true
  def err?({:ok, _val}), do: false
end
