defmodule RunLengthEncoder do
  @doc """
  Generates a string where consecutive elements are represented as a data value and count.
  "AABBBCCCC" => "2A3B4C"
  For this example, assume all input are strings, that are all uppercase letters.
  It should also be able to reconstruct the data into its original form.
  "2A3B4C" => "AABBBCCCC"
  """
  @spec encode(String.t) :: String.t
  def encode(string) do
    string
    |> String.codepoints
    |> Enum.chunk_by(&(&1))
    |> Enum.reduce("", fn(x, acc) ->
      char_amount = Enum.count(x)
      compressed_string = case char_amount do
                            1 -> hd(x)
                            _ -> (char_amount |> Integer.to_string) <> hd(x)
                          end

      acc <> compressed_string
    end)
  end

  @spec decode(String.t) :: String.t
  def decode(string) do
    Regex.scan(~r<\d+\w|\w | |\w>, string)
    |> List.flatten
    |> Enum.reduce("", fn(x, acc) ->
      decoded_char = case Regex.split(~r<\d+>, x, include_captures: true, trim: true) do
                       [char] -> char
                       [number, char] -> String.duplicate(char, String.to_integer(number))
                     end

      acc <> decoded_char
    end)
  end
end
