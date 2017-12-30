defmodule PigLatin do
  @doc """
  Given a `phrase`, translate it a word at a time to Pig Latin.

  Words beginning with consonants should have the consonant moved to the end of
  the word, followed by "ay".

  Words beginning with vowels (aeiou) should have "ay" added to the end of the
  word.

  Some groups of letters are treated like consonants, including "ch", "qu",
  "squ", "th", "thr", and "sch".

  Some groups are treated like vowels, including "yt" and "xr".
  """
  @spec translate(phrase :: String.t()) :: String.t()
  def translate(phrase) do
    phrase
    |> String.split()
    |> Enum.map(&translate_word(&1))
    |> Enum.join(" ")
  end

  defp translate_word(word) do
    cond do
      String.starts_with?(word, vowels()) -> word <> "ay"
      true -> translate_word_starts_with_consonants(word)
    end
  end

  defp translate_word_starts_with_consonants(word) do
    [consonants, rest] =
      String.split(word, additional_consonants(), include_captures: true, trim: true, parts: 2)

    rest <> consonants <> "ay"
  end

  defp vowels, do: ~w(a i u e o yt xr)
  defp additional_consonants, do: ~r(ch|qu|squ|thr|th|sch|[^aiueo])
end
