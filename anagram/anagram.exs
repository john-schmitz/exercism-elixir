defmodule Anagram do
  @doc """
  Returns all candidates that are anagrams of, but not equal to, 'base'.
  """
  @spec match(String.t(), [String.t()]) :: [String.t()]
  def match(base, candidates) do
    sorted_base = base |> sorted_codepoints()

    candidates
    |> Enum.reject(fn x -> String.downcase(base) == String.downcase(x) end)
    |> Enum.filter(fn x -> sorted_codepoints(x) == sorted_base end)
  end

  def sorted_codepoints(string) do
    string
    |> String.downcase()
    |> String.codepoints()
    |> Enum.sort()
    |> Enum.join()
  end
end
