defmodule PascalsTriangle do
  @doc """
  Calculates the rows of a pascal triangle
  with the given height
  """
  @spec rows(integer) :: [[integer]]
  def rows(1), do: [[1]]
  def rows(2), do: init_row() |> Enum.reverse()

  def rows(num) do
    num
    |> do_rows(init_row(), 2)
    |> Enum.reverse()
  end

  defp do_rows(num, triangle, current) when num == current, do: triangle

  defp do_rows(num, triangle, current) do
    new_row =
      triangle
      |> List.first()
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(&Enum.sum(&1))

    new_row = [1 | new_row] |> Kernel.++([1])

    do_rows(num, [new_row | init_row()], current + 1)
  end

  defp init_row, do: [[1, 1], [1]]
end
