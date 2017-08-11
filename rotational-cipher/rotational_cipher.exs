defmodule RotationalCipher do
  @doc """
  Given a plaintext and amount to shift by, return a rotated string.

  Example:
  iex> RotationalCipher.rotate("Attack at dawn", 13)
  "Nggnpx ng qnja"
  """
  @spec rotate(text :: String.t(), shift :: integer) :: String.t()
  def rotate(text, 0), do: text
  def rotate(text, 26), do: text

  def rotate(text, shift) do
    text
    |> String.to_charlist
    |> pmap(&(transform(&1, shift)))
    |> to_string
  end

  defp transform(char, shift) when char in ?A..?Z do
    do_transform(char, shift, ?A)
  end

  defp transform(char, shift) when char in ?a..?z do
    do_transform(char, shift, ?a)
  end

  defp transform(char, _), do: char

  defp do_transform(char, shift, wrapping_number) do
    wrapping_number + rem(char + shift - wrapping_number, 26)
  end

  defp pmap(list, fun) do
    me = self()
    list
    |> Enum.map(fn(i) ->
      spawn_link fn -> (send me, { self(), fun.(i) }) end
    end)
    |> Enum.map(fn (pid) ->
      receive do { ^pid, result } -> result end
    end)
  end
end

