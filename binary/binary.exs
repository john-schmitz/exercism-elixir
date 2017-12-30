defmodule Binary do
  @doc """
  Convert a string containing a binary number to an integer.

  On errors returns 0.
  """
  @spec to_decimal(String.t()) :: non_neg_integer
  def to_decimal(string) do
    cond do
      Regex.run(~r<[a-z]>, string) != nil -> 0
      Regex.run(~r<2>, string) != nil -> 0
      true -> do_convert(string)
    end
  end

  defp do_convert(string) do
    index_length = string |> String.length() |> Kernel.-(1)

    string
    |> String.codepoints()
    |> Enum.map(&String.to_integer(&1))
    |> Enum.reduce({index_length, 0}, fn x, {current_index, result} ->
      calculated_num =
        2
        |> :math.pow(current_index)
        |> Kernel.*(x)
        |> Kernel.+(result)

      {current_index - 1, calculated_num}
    end)
    |> Kernel.elem(1)
  end
end
