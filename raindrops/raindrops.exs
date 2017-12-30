defmodule Raindrops do
  @doc """
  Returns a string based on raindrop factors.

  - If the number contains 3 as a prime factor, output 'Pling'.
  - If the number contains 5 as a prime factor, output 'Plang'.
  - If the number contains 7 as a prime factor, output 'Plong'.
  - If the number does not contain 3, 5, or 7 as a prime factor,
    just pass the number's digits straight through.
  """
  @spec convert(pos_integer) :: String.t()
  def convert(number) do
    raindrops = do_convert(number)

    cond do
      String.length(raindrops) == 0 -> Integer.to_string(number)
      true -> raindrops
    end
  end

  def do_convert(number) do
    Enum.reduce(raindrop_mapping, "", fn {x, string}, acc ->
      cond do
        rem(number, x) == 0 -> acc <> string
        true -> acc
      end
    end)
  end

  defp raindrop_mapping do
    %{
      3 => "Pling",
      5 => "Plang",
      7 => "Plong"
    }
  end
end
