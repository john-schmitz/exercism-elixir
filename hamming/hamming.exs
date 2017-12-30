defmodule Hamming do
  @doc """
  Returns number of differences between two strands of DNA, known as the Hamming Distance.

  ## Examples

  iex> Hamming.hamming_distance('AAGTCATA', 'TAGCGATC')
  {:ok, 4}
  """
  @spec hamming_distance([char], [char]) :: non_neg_integer
  def hamming_distance(strand1, strand2) do
    with {:ok} <- check_length(strand1, strand2) do
      {:ok, do_calculation(strand1, strand2)}
    else
      {:error, error} -> {:error, error}
    end
  end

  defp do_calculation(strand1, strand2) do
    strand1
    |> Enum.zip(strand2)
    |> Enum.count(fn {x, y} -> x != y end)
  end

  def check_length(strand1, strand2) do
    case Enum.count(strand1) == Enum.count(strand2) do
      true -> {:ok}
      _ -> {:error, "Lists must be the same length"}
    end
  end
end
