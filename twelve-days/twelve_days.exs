defmodule TwelveDays do
  @doc """
  Given a `number`, return the song's verse for that specific day, including
  all gifts for previous days in the same line.
  """
  @spec verse(number :: integer) :: String.t()
  def verse(1), do: starting_text("first") <> present_by_number(1) <> "."
  def verse(number) do
    presents_until_2 = Enum.reduce(number..2, "", fn(x, acc) -> acc <> present_by_number(x) <> ", " end)
    {ordinal, _} = Map.get(presents(), number)
    "#{starting_text(ordinal)}#{presents_until_2}and #{present_by_number(1)}."
  end

  @doc """
  Given a `starting_verse` and an `ending_verse`, return the verses for each
  included day, one per line.
  """
  @spec verses(starting_verse :: integer, ending_verse :: integer) :: String.t()
  def verses(starting_verse, ending_verse) do
    Enum.map(starting_verse..ending_verse, fn(x) -> verse(x) end) |> Enum.join("\n")
  end

  @doc """
  Sing all 12 verses, in order, one verse per line.
  """
  @spec sing():: String.t()
  def sing do
    verses(1, 12)
  end

  defp starting_text(ordinal), do: String.replace(base_text(), "{}", ordinal)

  defp base_text, do: "On the {} day of Christmas my true love gave to me, "

  defp present_by_number(number) do
    {_, present} = Map.get(presents(), number)
    present
  end

  defp presents do
    %{
      1 => {"first", "a Partridge in a Pear Tree"},
      2 => {"second", "two Turtle Doves"},
      3 => {"third", "three French Hens"},
      4 => {"fourth", "four Calling Birds"},
      5 => {"fifth", "five Gold Rings"},
      6 => {"sixth", "six Geese-a-Laying"},
      7 => {"seventh", "seven Swans-a-Swimming"},
      8 => {"eighth", "eight Maids-a-Milking"},
      9 => {"ninth", "nine Ladies Dancing"},
      10 => {"tenth", "ten Lords-a-Leaping"},
      11 => {"eleventh", "eleven Pipers Piping"},
      12 => {"twelfth", "twelve Drummers Drumming"}
    }
  end
end

