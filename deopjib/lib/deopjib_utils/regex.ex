defmodule DeopjibUtils.Regex do
  # only_korean
  # ~r/^[ㄱ-힣]$/

  def general_name, do: ~r/^[ㄱ-힣a-zA-Z0-9_ !@#$%^&*()₩-]+$/u
end
