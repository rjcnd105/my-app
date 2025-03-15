defmodule Deopjib.Utils.Enum do
  def fetch(enum, index) when is_integer(index) and index >= 0 do
    Enum.fetch(enum, index)
  end
end
