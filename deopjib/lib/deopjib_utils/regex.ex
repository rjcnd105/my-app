defmodule DeopjibUtils.Regex do
  # @only_korean ~r/^[ㄱ-힣]$/

  @general_name ~r/^[ㄱ-힣a-zA-Z0-9_ !@#$%^&*()₩-]+$/u

  def general_name, do: @general_name
end
