defmodule Phone do
  @doc """
  Remove formatting from a phone number.

  Returns "0000000000" if phone number is not valid
  (10 digits or "1" followed by 10 digits)

  ## Examples

  iex> Phone.number("212-555-0100")
  "2125550100"

  iex> Phone.number("+1 (212) 555-0100")
  "2125550100"

  iex> Phone.number("+1 (212) 055-0100")
  "0000000000"

  iex> Phone.number("(212) 555-0100")
  "2125550100"

  iex> Phone.number("867.5309")
  "0000000000"
  """
  @spec number(String.t) :: String.t
  def number(raw) do
    raw
    |> clean
    |> is_good_length?
    |> legible_number?
    |> legit_country_code?
    |> legit_local_code?
    |> legit_exchange_code?
  end

  defp legit_exchange_code?(phone_number) do
    exchange_code = phone_number |> String.at(3)
    case exchange_code do
      "1" -> invalid_return()
      "0" -> invalid_return()
      _ -> phone_number
    end
  end

  defp legit_local_code?(phone_number) do
    local_code_checking = String.length(phone_number) == 10 &&
      (String.starts_with?(phone_number, na_code()) ||
      String.starts_with?(phone_number, "0"))

    case local_code_checking do
      false -> phone_number
      true -> invalid_return()
    end
  end

  defp legit_country_code?(phone_number) do
    country_code_checking = String.length(phone_number) == 11 && !String.starts_with?(phone_number, na_code())

    case country_code_checking do
      false -> phone_number
      true -> invalid_return()
    end
  end

  defp legible_number?(phone_number) do
    case Regex.run(~r<[a..z]>, phone_number) == nil do
      true -> phone_number
      false -> invalid_return()
    end
  end

  defp is_good_length?(phone_number) do
    case String.length(phone_number) > 9 do
      true -> phone_number
      false -> invalid_return()
    end
  end

  defp clean(raw) do
    raw
    |> String.replace(~r<^\+1|^1|\.| |-|\(|\)>, "")
  end

  defp invalid_return, do: "0000000000"
  defp na_code, do: "1"

  @doc """
  Extract the area code from a phone number

  Returns the first three digits from a phone number,
  ignoring long distance indicator

  ## Examples

  iex> Phone.area_code("212-555-0100")
  "212"

  iex> Phone.area_code("+1 (212) 555-0100")
  "212"

  iex> Phone.area_code("+1 (012) 555-0100")
  "000"

  iex> Phone.area_code("867.5309")
  "000"
  """
  @spec area_code(String.t) :: String.t
  def area_code(raw) do
  end

  @doc """
  Pretty print a phone number

  Wraps the area code in parentheses and separates
  exchange and subscriber number with a dash.

  ## Examples

  iex> Phone.pretty("212-555-0100")
  "(212) 555-0100"

  iex> Phone.pretty("212-155-0100")
  "(000) 000-0000"

  iex> Phone.pretty("+1 (303) 555-1212")
  "(303) 555-1212"

  iex> Phone.pretty("867.5309")
  "(000) 000-0000"
  """
  @spec pretty(String.t) :: String.t
  def pretty(raw) do
  end
end
