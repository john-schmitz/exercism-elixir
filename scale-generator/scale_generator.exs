defmodule ScaleGenerator do
  @doc """
  Find the note for a given interval (`step`) in a `scale` after the `tonic`.

  "m": one semitone
  "M": two semitones (full tone)
  "A": augmented second (three semitones)

  Given the `tonic` "D" in the `scale` (C C# D D# E F F# G G# A A# B C), you
  should return the following notes for the given `step`:

  "m": D#
  "M": E
  "A": F
  """
  @spec step(scale :: list(String.t()), tonic :: String.t(), step :: String.t()) ::
          list(String.t())
  def step(scale, tonic, step) do
    tonic_index = scale |> Enum.find_index(&(&1 == String.capitalize(tonic)))
    step_count = steps() |> Map.get(step)
    stepped_index = tonic_index + step_count
    scale |> Enum.at(stepped_index)
  end

  defp steps, do: %{"m" => 1, "M" => 2, "A" => 3}

  @doc """
  The chromatic scale is a musical scale with thirteen pitches, each a semitone
  (half-tone) above or below another.

  Notes with a sharp (#) are a semitone higher than the note below them, where
  the next letter note is a full tone except in the case of B and E, which have
  no sharps.

  Generate these notes, starting with the given `tonic` and wrapping back
  around to the note before it, ending with the tonic an octave higher than the
  original. If the `tonic` is lowercase, capitalize it.

  "C" should generate: ~w(C C# D D# E F F# G G# A A# B C)
  """
  @spec chromatic_scale(tonic :: String.t()) :: list(String.t())
  def chromatic_scale(tonic \\ "C") do
    capitalized_tonic = tonic |> String.capitalize()
    do_chromatic_scale(capitalized_tonic, 1) ++ [capitalized_tonic]
  end

  defp do_chromatic_scale(_, 13), do: []

  defp do_chromatic_scale(tonic, count) do
    next_tonic =
      case !Enum.member?(no_sharps(), tonic) && !String.contains?(tonic, "#") do
        true -> "#{tonic}#"
        false -> tonic |> String.replace("#", "") |> increment_tonic
      end

    [tonic | do_chromatic_scale(next_tonic, count + 1)]
  end

  defp no_sharps, do: ~w(B E)

  defp increment_tonic(tonic) do
    incremented_tonic =
      tonic
      |> String.to_charlist()
      |> hd
      |> Kernel.+(1)

    next_tonic =
      case incremented_tonic do
        72 -> 65
        _ -> incremented_tonic
      end

    [next_tonic] |> to_string
  end

  @doc """
  Sharp notes can also be considered the flat (b) note of the tone above them,
  so the notes can also be represented as:

  A Bb B C Db D Eb E F Gb G Ab

  Generate these notes, starting with the given `tonic` and wrapping back
  around to the note before it, ending with the tonic an octave higher than the
  original. If the `tonic` is lowercase, capitalize it.

  "C" should generate: ~w(C Db D Eb E F Gb G Ab A Bb B C)
  """
  @spec flat_chromatic_scale(tonic :: String.t()) :: list(String.t())
  def flat_chromatic_scale(tonic \\ "C") do
    capitalized_tonic = tonic |> String.capitalize()
    do_flat_chromatic_scale(capitalized_tonic, 1) ++ [capitalized_tonic]
  end

  defp do_flat_chromatic_scale(_, 13), do: []

  defp do_flat_chromatic_scale(tonic, count) do
    next_tonic =
      case String.contains?(tonic, "b") do
        true ->
          <<note, _>> = tonic
          [note] |> to_string

        false ->
          increment_tonic(tonic) |> append_flat
      end

    [tonic | do_flat_chromatic_scale(next_tonic, count + 1)]
  end

  defp no_flats, do: ~w(C F)

  defp append_flat(tonic) do
    case Enum.member?(no_flats(), tonic) do
      true -> tonic
      false -> "#{tonic}b"
    end
  end

  @doc """
  Certain scales will require the use of the flat version, depending on the
  `tonic` (key) that begins them, which is C in the above examples.

  For any of the following tonics, use the flat chromatic scale:

  F Bb Eb Ab Db Gb d g c f bb eb

  For all others, use the regular chromatic scale.
  """
  @spec find_chromatic_scale(tonic :: String.t()) :: list(String.t())
  def find_chromatic_scale(tonic) do
    case Enum.member?(starting_keys_for_flat(), tonic) do
      true -> flat_chromatic_scale(tonic)
      false -> chromatic_scale(tonic)
    end
  end

  defp starting_keys_for_flat, do: ~w(F Bb Eb Ab Db Gb d g c f bb eb)

  @doc """
  The `pattern` string will let you know how many steps to make for the next
  note in the scale.

  For example, a C Major scale will receive the pattern "MMmMMMm", which
  indicates you will start with C, make a full step over C# to D, another over
  D# to E, then a semitone, stepping from E to F (again, E has no sharp). You
  can follow the rest of the pattern to get:

  C D E F G A B C
  """
  @spec scale(tonic :: String.t(), pattern :: String.t()) :: list(String.t())
  def scale(tonic, pattern) do
    capitalized_tonic = tonic |> String.capitalize()

    tonic
    |> find_chromatic_scale
    |> do_generate(tonic, String.split(pattern, "", trim: true))
    |> Kernel.++([capitalized_tonic])
  end

  defp do_generate(_, _, []), do: []

  defp do_generate(scale, tonic, [head | tail]) do
    next_tonic = step(scale, tonic, head)
    [String.capitalize(tonic) | do_generate(scale, next_tonic, tail)]
  end
end
