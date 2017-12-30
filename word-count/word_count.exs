defmodule Words do
  @doc """
  Count the number of words in the sentence.

  Words are compared case-insensitively.
  """
  @spec count(String.t()) :: map
  def count(sentence) do
    sentence
    |> String.replace(~r<,|!|&|@|\$|%|\^|:>, "")
    |> String.split(~r< |_>, trim: true)
    |> do_count(%{})
  end

  def do_count([], result), do: result

  def do_count([head | tail], result) do
    do_count(
      tail,
      Map.update(result, String.downcase(head), 1, fn current_value -> current_value + 1 end)
    )
  end
end
