defmodule Triangle do
  @type kind :: :equilateral | :isosceles | :scalene

  @doc """
  Return the kind of triangle of a triangle with 'a', 'b' and 'c' as lengths.
  """
  @spec kind(number, number, number) :: {:ok, kind} | {:error, String.t()}
  def kind(a, b, c) do
    triangle = [a, b, c]

    with {:ok} <- check_side_positivity(triangle),
         {:ok} <- check_side_equality(triangle) do
      {:ok, decide_kind(triangle)}
    else
      {:error, error} -> {:error, error}
    end
  end

  defp decide_kind(triangle) do
    triangle |> Enum.uniq() |> Enum.count()

    case triangle |> Enum.uniq() |> Enum.count() do
      1 -> :equilateral
      2 -> :isosceles
      _ -> :scalene
    end
  end

  defp check_side_positivity(triangle) do
    case triangle |> Enum.all?(&(&1 > 0)) do
      true -> {:ok}
      _ -> {:error, "all side lengths must be positive"}
    end
  end

  defp check_side_equality(triangle) do
    max_value = triangle |> Enum.max()
    rest = triangle |> List.delete(max_value)

    case Enum.sum(rest) > max_value do
      true -> {:ok}
      _ -> {:error, "side lengths violate triangle inequality"}
    end
  end
end
