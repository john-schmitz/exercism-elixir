defmodule StringSeries do
  @doc """
  Given a string `s` and a positive integer `size`, return all substrings
  of that size. If `size` is greater than the length of `s`, or less than 1,
  return an empty list.
  """

  @spec slices(s :: String.t(), size :: integer) :: list(String.t())
  def slices(_string, size) when size < 1, do: []
  def slices(string, size) when byte_size(string) < size, do: []
  def slices(string, size), do: do_slices(string, 0, size)

  def do_slices(string, index, size) do
    cond do
      index + size > String.length(string) -> []
      true -> [String.slice(string, index, size) | do_slices(string, index + 1, size)]
    end
  end
end
