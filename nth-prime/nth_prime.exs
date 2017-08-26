defmodule Prime do

  @doc """
  Generates the nth prime.
  """
  @spec nth(non_neg_integer) :: non_neg_integer
  def nth(count) when count < 1, do: raise ArgumentError
  def nth(1), do: 2
  def nth(2), do: 3
  def nth(count) do
    do_nth(count, 3, 5, [2, 3])
  end

  def do_nth(count, order, number, primes) do
    multipliable = primes |> Enum.any?(&(rem(number, &1) == 0))
    cond do
      multipliable -> do_nth(count, order, number + 1, primes)
      !multipliable &&(count == order) -> number
      true -> do_nth(count, order + 1, number + 1, [number | primes])
    end
  end
end
