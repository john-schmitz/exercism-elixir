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
    cleaned_phone_number = raw |> clean
    with {:ok, phone_number} <- is_good_length?(cleaned_phone_number),
        {:ok, phone_number} <- legible_number?(phone_number),
        {:ok, phone_number} <- legit_country_code?(phone_number),
        {:ok, phone_number} <- legit_local_code?(phone_number),
        {:ok, phone_number} <- legit_exchange_code?(phone_number)
    do
      phone_number
    else
      # We should give the caller a better information about the error message as well,
      # so it knows what goes wrong. But, the test only need "0000000000", which is very unfortunate.
      {:error, _} -> invalid_return()
    end
  end

  defp legit_exchange_code?(phone_number) do
    exchange_code = phone_number |> String.at(3)
    case exchange_code do
      "1" -> {:error, "Invalid Exchange Code. Exchange code must not start with #{na_code()} or 0."}
      "0" -> {:error, "Invalid Exchange Code. Exchange code must not start with #{na_code()} or 0."}
      _ -> {:ok, phone_number}
    end
  end

  defp legit_local_code?(phone_number) do
    local_code_checking = String.length(phone_number) == 10 &&
      (String.starts_with?(phone_number, na_code()) ||
      String.starts_with?(phone_number, "0"))

    case local_code_checking do
      false -> {:ok, phone_number}
      true -> {:error, "Invalid Local Code. Local code must not start with #{na_code()} or 0."}
    end
  end

  defp legit_country_code?(phone_number) do
    country_code_checking = String.length(phone_number) == 11 && !String.starts_with?(phone_number, na_code())

    case country_code_checking do
      false -> {:ok, phone_number}
      true -> {:error, "Invalid Country Code. Country code must be #{na_code()}"}
    end
  end

  defp legible_number?(phone_number) do
    case Regex.run(~r<[a..z]>, phone_number) == nil do
      true -> {:ok, phone_number}
      false -> {:error, "Invalid Format. Must not contain any letter."}
    end
  end

  defp is_good_length?(phone_number) do
    case String.length(phone_number) > valid_phone_length() do
      true -> {:ok, phone_number}
      false -> {:error, "Invalid Length. Phone number length should be more than #{valid_phone_length()} digits."}
    end
  end

  defp clean(raw) do
    raw
    |> String.replace(~r<^\+1|^1|\.| |-|\(|\)>, "")
  end

  defp invalid_return, do: "0000000000"
  defp na_code, do: "1"
  defp valid_phone_length, do: 9

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
    raw
    |> number
    |> String.slice(0..2)
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
    phone_number = raw |> number
    exchange_number = phone_number |> String.slice(3..5)
    subscriber_number = phone_number |> String.slice(6..9)
    "(#{area_code(raw)}) #{exchange_number}-#{subscriber_number}"
  end
end
