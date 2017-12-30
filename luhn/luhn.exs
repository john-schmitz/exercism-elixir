defmodule Luhn do
  @doc """
  Calculates the total checksum of a number
  """
  @spec checksum(String.t()) :: integer
  def checksum(number) do
    number
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer(&1))
    |> Enum.reverse()
    |> do_checksum(0)
  end

  def do_checksum([], result), do: result
  def do_checksum([last], result), do: result + last

  def do_checksum([head | [head2 | tail]], result) do
    do_checksum(tail, result + head + do_double(head2))
  end

  def do_double(num) do
    case num * 2 do
      doubled when doubled > 9 -> doubled - 9
      doubled -> doubled
    end
  end

  @doc """
  Checks if the given number is valid via the luhn formula
  """
  @spec valid?(String.t()) :: boolean
  def valid?(number) do
    case checksum(number) do
      checksum_result when rem(checksum_result, 10) == 0 -> true
      _ -> false
    end
  end

  @doc """
  Creates a valid number by adding the correct
  checksum digit to the end of the number
  """
  @spec create(String.t()) :: String.t()
  def create(number) do
    adder =
      case checksum("#{number}0") do
        checksum_result when checksum_result == 10 -> 0
        checksum_result -> 10 - rem(checksum_result, 10)
      end

    "#{number}#{adder}"
  end
end
