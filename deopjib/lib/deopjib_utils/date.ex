defmodule DeopjibUtils.Date do
  def simple_datetime_format(%DateTime{} = datetime) do
    yy = datetime.year |> Integer.mod(100) |> Integer.to_string()
    mm = datetime.month |> fill_zero()
    day = datetime.day |> fill_zero()
    hour = datetime.hour |> fill_zero()
    minute = datetime.minute |> fill_zero()

    "#{yy}.#{mm}.#{day} #{hour}:#{minute}"
  end

  def fill_zero(number, pad_length \\ 2) do
    number |> Integer.to_string() |> String.pad_leading(pad_length, "0")
  end
end
