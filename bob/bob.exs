defmodule Bob do
  def hey(input) do
    cond do
      is_asking?(input) -> "Sure."
      is_silence?(input) -> "Fine. Be that way!"
      is_shouting?(input) -> "Whoa, chill out!"
      true -> "Whatever."
    end
  end

  defp is_asking?(input), do: String.ends_with?(input, "?")
  defp is_silence?(input), do: String.trim(input) == ""
  defp is_shouting?(input), do: String.upcase(input) == input && String.downcase(input) !== String.upcase(input)

end
