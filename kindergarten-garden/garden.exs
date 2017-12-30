defmodule Garden do
  @doc """
    Accepts a string representing the arrangement of cups on a windowsill and a
    list with names of students in the class. The student names list does not
    have to be in alphabetical order.

    It decodes that string into the various gardens for each student and returns
    that information in a map.
  """

  @spec info(String.t(), list) :: map
  def info(info_string, student_names \\ default_children()) do
    [upper, lower] =
      info_string
      |> String.graphemes()
      |> Enum.chunk_by(&(&1 == "\n"))
      |> Enum.reject(&(&1 == ["\n"]))

    student_names
    |> Enum.sort()
    |> do_info(upper, lower, %{})
  end

  defp do_info([], _upper, _lower, result), do: result

  defp do_info([head | tail], upper, lower, result) when upper == [] or lower == [] do
    do_info(tail, [], [], Map.put(result, head, {}))
  end

  defp do_info(
         [head | tail],
         [first | [second | upper_rest]],
         [third | [fourth | lower_rest]],
         result
       ) do
    plants =
      [first, second, third, fourth]
      |> Enum.reduce({}, fn x, acc ->
        Tuple.append(acc, Map.get(plants_mapping(), x))
      end)

    do_info(tail, upper_rest, lower_rest, Map.put(result, head, plants))
  end

  defp default_children,
    do: ~w<alice bob charlie david eve fred ginny harriet ileana joseph kincaid larry>a

  defp plants_mapping, do: %{"V" => :violets, "R" => :radishes, "C" => :clover, "G" => :grass}
end
