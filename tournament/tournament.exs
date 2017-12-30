defmodule Tournament do
  @doc """
  Given `input` lines representing two teams and whether the first of them won,
  lost, or reached a draw, separated by semicolons, calculate the statistics
  for each team's number of games played, won, drawn, lost, and total points
  for the season, and return a nicely-formatted string table.

  A win earns a team 3 points, a draw earns 1 point, and a loss earns nothing.

  Order the outcome by most total points for the season, and settle ties by
  listing the teams in alphabetical order.
  """
  @spec tally(input :: list(String.t())) :: String.t()
  def tally(input) do
    input
    |> Enum.reduce(%{}, fn x, acc ->
      case String.split(x, ";") do
        [home, away, result] ->
          case result do
            "win" ->
              acc
              |> Map.update(home, [:o], &[:o | &1])
              |> Map.update(away, [:x], &[:x | &1])

            "draw" ->
              acc
              |> Map.update(home, [:d], &[:d | &1])
              |> Map.update(away, [:d], &[:d | &1])

            "loss" ->
              acc
              |> Map.update(home, [:x], &[:x | &1])
              |> Map.update(away, [:o], &[:o | &1])

            _ ->
              acc
          end

        _ ->
          acc
      end
    end)
    |> Map.to_list()
    |> Enum.map(&process_team(&1))
    |> Enum.sort(fn team_1, team_2 ->
      {_, _, _, _, _, _, results_1} = team_1
      {_, _, _, _, _, _, results_2} = team_2
      results_1 >= results_2
    end)
    |> pretty_table
  end

  defp process_team(results) do
    {_team, fixtures} = results

    wins = fixtures |> Enum.count(&(&1 == :o))
    draws = fixtures |> Enum.count(&(&1 == :d))
    losses = fixtures |> Enum.count(&(&1 == :x))
    score = 3 * wins + draws
    match_played = wins + draws + losses

    results
    |> Tuple.append(match_played)
    |> Tuple.append(wins)
    |> Tuple.append(draws)
    |> Tuple.append(losses)
    |> Tuple.append(score)
  end

  defp pretty_table(results) do
    score_board =
      results
      |> Enum.reduce("", fn x, acc ->
        {team, _fixtures, mp, w, d, l, p} = x
        team_name = String.pad_trailing("#{team}", team_row_max_length())
        mp_string = String.pad_leading("#{mp}", 3)
        w_string = String.pad_leading("#{w}", 3)
        d_string = String.pad_leading("#{d}", 3)
        l_string = String.pad_leading("#{l}", 3)
        p_string = String.pad_leading("#{p}", 3)

        team_row =
          "\n#{team_name}|#{mp_string} |#{w_string} |#{d_string} |#{l_string} |#{p_string}"

        acc <> team_row
      end)

    table_header <> score_board
  end

  defp table_header do
    "Team                           | MP |  W |  D |  L |  P"
  end

  defp team_row_max_length, do: 31
end
