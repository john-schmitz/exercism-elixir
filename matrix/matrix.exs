defmodule Matrix do
  defstruct matrix: nil

  @doc """
  Convert an `input` string, with rows separated by newlines and values
  separated by single spaces, into a `Matrix` struct.
  """
  @spec from_string(input :: String.t()) :: %Matrix{}
  def from_string(input) do
    input
    |> String.split("\n")
    |> Enum.reduce({%Matrix{}, 0}, fn x, {acc, index} ->
      {Map.put(acc, index, x), index + 1}
    end)
    |> elem(0)
  end

  @doc """
  Write the `matrix` out as a string, with rows separated by newlines and
  values separated by single spaces.
  """
  @spec to_string(matrix :: %Matrix{}) :: String.t()
  def to_string(matrix) do
    matrix
    |> Map.from_struct()
    |> Map.values()
    |> Enum.reject(&(&1 == nil))
    |> Enum.join("\n")
  end

  @doc """
  Given a `matrix`, return its rows as a list of lists of integers.
  """
  @spec rows(matrix :: %Matrix{}) :: list(list(integer))
  def rows(matrix) do
    matrix
    |> Map.from_struct()
    |> Map.values()
    |> Stream.reject(&(&1 == nil))
    |> Enum.map(&column_convert_to_integer(&1))
  end

  defp column_convert_to_integer(column) do
    column
    |> String.split()
    |> Enum.map(&String.to_integer(&1))
  end

  @doc """
  Given a `matrix` and `index`, return the row at `index`.
  """
  @spec row(matrix :: %Matrix{}, index :: integer) :: list(integer)
  def row(matrix, index) do
    Map.get(matrix, index)
    |> column_convert_to_integer
  end

  @doc """
  Given a `matrix`, return its columns as a list of lists of integers.
  """
  @spec columns(matrix :: %Matrix{}) :: list(list(integer))
  def columns(matrix) do
    matrix
    |> Map.from_struct()
    |> Map.values()
    |> Stream.reject(&(&1 == nil))
    |> Enum.map(&column_convert_to_integer(&1))
    |> transpose
  end

  defp transpose([[] | _]), do: []

  defp transpose(matrix_list) do
    [Enum.map(matrix_list, &hd(&1)) | transpose(Enum.map(matrix_list, &tl(&1)))]
  end

  @doc """
  Given a `matrix` and `index`, return the column at `index`.
  """
  @spec column(matrix :: %Matrix{}, index :: integer) :: list(integer)
  def column(matrix, index) do
    columns(matrix)
    |> Enum.at(index)
  end
end
