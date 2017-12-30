defmodule Gigasecond do
  @doc """
  Calculate a date one billion seconds after an input date.
  A gigasecond is 10^9 (1,000,000,000) seconds.
  """
  @spec from({{pos_integer, pos_integer, pos_integer}, {pos_integer, pos_integer, pos_integer}}) ::
          :calendar.datetime()

  def from(datetime) do
    {:ok, naive_datetime} = datetime |> NaiveDateTime.from_erl()
    naive_datetime |> NaiveDateTime.add(1_000_000_000) |> NaiveDateTime.to_erl()
  end
end
