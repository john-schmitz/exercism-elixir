defmodule AllYourBase do
  @doc """
  Given a number in base a, represented as a sequence of digits, converts it to base b,
  or returns nil if either of the bases are less than 2
  """
  @spec convert(list, integer, integer) :: list | nil
  def convert(_list, base_a, base_b) when base_a < 2 or base_b < 2, do: nil
  def convert([], _base_a, _base_b), do: nil

  def convert(digits, base_a, 10) do
    with {:ok} <- check_positivity(digits),
         {:ok} <- check_validity(digits, base_a) do
      do_convert(digits, base_a, 10)
    else
      {:error, _} -> nil
    end
  end

  def convert(digits, 10, base_b) do
    digits
    |> Enum.join()
    |> String.to_integer()
    |> convert_from_base_10(base_b)
    |> clean_leading_zero
  end

  def convert(digits, base_a, base_b) do
    digits |> convert(base_a, 10) |> convert(10, base_b)
  end

  defp do_convert(digits, base_a, 10) do
    index_length = Enum.count(digits) - 1

    digits
    |> Enum.reduce({index_length, 0}, fn x, {current_index, result} ->
      calculated_num =
        base_a
        |> :math.pow(current_index)
        |> Kernel.*(x)
        |> Kernel.+(result)

      {current_index - 1, calculated_num}
    end)
    |> Kernel.elem(1)
    |> round
    |> Integer.to_string()
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer(&1))
  end

  def check_positivity(digits) do
    case digits |> Enum.all?(&(&1 > -1)) do
      true -> {:ok}
      _ -> {:error, "Digits contains negative numbers."}
    end
  end

  def check_validity(digits, base) do
    case digits |> Enum.all?(&(&1 < base)) do
      true -> {:ok}
      _ -> {:error, "Digits contains invalid numbers."}
    end
  end

  defp clean_leading_zero(digits) do
    cond do
      hd(digits) == 0 and Enum.count(digits) > 1 ->
        List.delete_at(digits, 0)

      true ->
        digits
    end
  end

  defp convert_from_base_10(0, _base), do: [0]

  defp convert_from_base_10(num, base) do
    rest = num |> Kernel./(base) |> Float.floor() |> round
    remainder = num |> rem(base)
    convert_from_base_10(rest, base) ++ [remainder]
  end
end
