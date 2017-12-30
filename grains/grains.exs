defmodule Grains do
  @doc """
  Calculate two to the power of the input minus one.
  """
  @spec square(pos_integer) :: pos_integer
  def square(number) when number not in 1..64,
    do: {:error, "The requested square must be between 1 and 64 (inclusive)"}

  def square(number, result \\ 1)
  def square(1, result), do: {:ok, result}
  def square(number, result), do: square(number - 1, result * 2)

  @doc """
  Adds square of each number from 1 to 64.
  """
  @spec total :: pos_integer
  def total do
    result =
      Enum.reduce(1..64, 0, fn x, acc ->
        with {:ok, squared} <- square(x), do: acc + squared
      end)

    {:ok, result}
  end
end
