defmodule Frequency do
  @doc """
  Count letter frequency in parallel.

  Returns a map of characters to frequencies.

  The number of worker processes to use can be set with 'workers'.
  """
  @spec frequency([String.t], pos_integer) :: map
  def frequency([], _), do: %{}
  def frequency(texts, workers) do
    joined_texts = texts
    |> Enum.join
    |> String.replace(~r<[,.?\'! ;\-\d]>, "")
    |> String.downcase
    |> String.codepoints

    chunk = joined_texts
    |> Enum.count
    |> Kernel./(workers)
    |> Float.ceil
    |> Kernel.round

    do_frequency(joined_texts, chunk)
  end

  defp do_frequency([], _), do: %{}
  defp do_frequency(joined_texts, chunk) do
    joined_texts
    |> Enum.chunk_every(chunk)
    |> Enum.map(fn(x) ->
      Task.async(__MODULE__, :char_count, [x])
    end)
    |> Enum.map(&(Task.await(&1)))
    |> Enum.reduce(%{}, fn(x, acc) ->
      Map.merge(x, acc, fn(_key, v1, v2) ->
        v1 + v2
      end)
    end)
  end

  def char_count(text, acc \\ %{})
  def char_count([], acc), do: acc
  def char_count([head | tail], acc) do
    char_count(tail, Map.update(acc, head, 1, &(&1 + 1)))
  end
end
