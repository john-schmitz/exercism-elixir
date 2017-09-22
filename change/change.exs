defmodule Change do
  @doc """
    Determine the least number of coins to be given to the user such
    that the sum of the coins' value would equal the correct amount of change.
    It returns {:error, "cannot change"} if it is not possible to compute the
    right amount of coins. Otherwise returns the tuple {:ok, list_of_coins}

    ## Examples

      iex> Change.generate([5, 10, 15], 3)
      {:error, "cannot change"}

      iex> Change.generate([1, 5, 10], 18)
      {:ok, [1, 1, 1, 5, 10]}

  """

  @spec generate(list, integer) :: {:ok, list} | {:error, String.t}
  def generate(_, target) when target < 0, do: { :error, "cannot change" }
  def generate(_, target) when target == 0, do: { :ok, [] }
  def generate(coins, target) do
    solutions = coins
    |> Enum.reject(&(&1 > target))
    |> Enum.with_index
    |> Enum.map(fn { _, index } ->
      coins
      |> List.delete_at(index)
      |> Enum.reverse
      |> do_generate(target)
    end)
    |> Enum.filter(&(Enum.sum(&1) == target))
    case Enum.empty?(solutions) do
      true ->
        { :error, "cannot change" }
      false ->
        change = solutions
        |> Enum.min_by(&length/1)
        |> Enum.reverse

        { :ok, change }
    end
  end

  defp do_generate([], _), do: []
  defp do_generate([ head | tail ], target_rest) when head > target_rest, do: do_generate(tail, target_rest)
  defp do_generate([ head | tail ], target_rest) when head == target_rest, do: [ head | do_generate(tail, target_rest - head) ]
  defp do_generate(all = [ head | tail ], target_rest) do
    cond do
      !Enum.empty?(tail) && List.last(tail) > target_rest - head
        -> do_generate(tail, target_rest)
      true
        -> [ head | do_generate(all, target_rest - head) ]
    end
  end

end
