# This test should use the standard chess notation instead.
defmodule Queens do
  @type t :: %Queens{black: {integer, integer}, white: {integer, integer}}
  defstruct black: nil, white: nil

  @doc """
  Creates a new set of Queens
  """
  @spec new() :: Queens.t()
  @spec new({integer, integer}, {integer, integer}) :: Queens.t()
  def new(white \\ {0, 3}, black \\ {7, 3})
  def new(white, black) when white == black, do: raise(ArgumentError)

  def new(white, black) do
    %Queens{white: white, black: black}
  end

  @doc """
  Gives a string reprentation of the board with
  white and black queen locations shown
  """
  @spec to_string(Queens.t()) :: String.t()
  def to_string(queens) do
    for m <- 0..7,
        n <- 0..7 do
      cond do
        {m, n} == queens.white -> "W"
        {m, n} == queens.black -> "B"
        true -> "_"
      end
    end
    |> Enum.chunk_every(8)
    |> Enum.map(&Enum.join(&1, " "))
    |> Enum.join("\n")
  end

  @doc """
  Checks if the queens can attack each other
  """
  @spec can_attack?(Queens.t()) :: boolean
  def can_attack?(queens) do
    {white_x, white_y} = queens.white
    {black_x, black_y} = queens.black

    cond do
      white_x == black_x || white_y == black_y -> true
      abs(white_x - white_y) == abs(black_x - black_y) -> true
      true -> false
    end
  end
end
