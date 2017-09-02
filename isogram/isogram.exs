defmodule Isogram do
  @doc """
  Determines if a word or sentence is an isogram
  """
  @spec isogram?(String.t) :: boolean
  def isogram?(sentence) do
    sentence = sentence |> String.replace(~r< |->, "")
    sentence
    |> String.to_charlist
    |> Enum.uniq
    |> Enum.count == String.length(sentence)
  end

end
