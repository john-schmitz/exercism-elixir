defmodule SumOfMultiples do
  @doc """
  Adds up all numbers from 1 to a given end number that are multiples of the factors provided.
  """
  @spec to(non_neg_integer, [non_neg_integer]) :: non_neg_integer
  def to(limit, factors) do
    for(
      x <- 1..(limit - 1),
      y <- factors,
      rem(x, y) == 0,
      do: x
    )
    |> Enum.uniq()
    |> Enum.sum()
  end
end
