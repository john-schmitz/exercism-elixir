defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """

  @type weekday ::
      :monday | :tuesday | :wednesday
    | :thursday | :friday | :saturday | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: :calendar.date
  def meetup(year, month, weekday, schedule) do
    starter_day = case schedule do
                    :teenth -> 13
                    _ -> 1
                  end

    {:ok, first_date} = Date.new(year, month, starter_day)
    first_wday = Date.day_of_week(first_date)

    scheduled_wday = weekday |> day_to_wday
    diff = 8 - (first_wday - scheduled_wday)
    scheduled_day = case diff > 7 do
                      true -> diff - 7
                      false -> diff
                    end

    day = scheduled_day + Map.get(days_adder(), schedule)
    calculated_day = cond do
      schedule == :last && Date.days_in_month(first_date) >= day + 7
      -> day + 7
      true -> day
    end

    {year, month, calculated_day}
  end

  defp wday_mapping, do: ~w<monday tuesday wednesday thursday friday saturday sunday>a
  defp day_to_wday(wday), do: Enum.find_index(wday_mapping(), &(&1 == wday)) + 1
  defp days_adder, do: %{first: 0, second: 7, third: 14, fourth: 21, teenth: 12, last: 21}
end
