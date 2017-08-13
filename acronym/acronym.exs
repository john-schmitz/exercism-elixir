defmodule Acronym do
  defp abbreviate_word(word) do
    word
    |> Macro.underscore
    |> String.split("_")
    |> Enum.reduce("", fn(x, acc) ->
      acc <> (String.at(x, 0) |> String.upcase)
    end)
  end

  @doc """
  Generate an acronym from a string.
  "This is a string" => "TIAS"
  """
  @spec abbreviate(String.t()) :: String.t()
  def abbreviate(string) do
    string
    |> String.replace(~r<,>, "")
    |> String.split(~r< |->)
    |> Enum.map(&(abbreviate_word/1))
    |> Enum.join
  end
end
