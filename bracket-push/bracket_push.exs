defmodule BracketPush do
  @doc """
  Checks that all the brackets and braces in the string are matched correctly, and nested correctly
  """
  @spec check_brackets(String.t()) :: boolean
  def check_brackets(str) do
    Regex.scan(~r<[\{\}\[\]\(\)]>, str)
    |> List.flatten()
    |> do_check_brackets([])
  end

  def do_check_brackets([], []), do: true
  def do_check_brackets([], _), do: false

  def do_check_brackets([head | tail], pushed) do
    cond do
      head in Map.keys(brackets_mapping) ->
        do_check_brackets(tail, [head | pushed])

      head in Map.values(brackets_mapping) ->
        cond do
          Enum.empty?(pushed) ->
            false

          head == Map.get(brackets_mapping(), hd(pushed)) ->
            [_ | rest] = pushed
            do_check_brackets(tail, rest)

          head != Map.get(brackets_mapping(), hd(pushed)) ->
            false
        end
    end
  end

  def brackets_mapping do
    %{
      "{" => "}",
      "[" => "]",
      "(" => ")"
    }
  end
end
