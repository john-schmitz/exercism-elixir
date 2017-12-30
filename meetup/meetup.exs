defmodule Meetup do
  @moduledoc """
  Calculate meetup dates.
  """

  @type weekday ::
          :monday
          | :tuesday
          | :wednesday
          | :thursday
          | :friday
          | :saturday
          | :sunday

  @type schedule :: :first | :second | :third | :fourth | :last | :teenth

  @doc """
  Calculate a meetup date.

  The schedule is in which week (1..4, last or "teenth") the meetup date should
  fall.
  """
  @spec meetup(pos_integer, pos_integer, weekday, schedule) :: :calendar.date()
  def meetup(year, month, weekday, schedule) do
    # Try to find out, what wday(1 to 7 related to monday to sunday)
    # is the very first wday of the valid date range.
    # :teenth starts with 13.
    starter_day =
      case schedule do
        :teenth -> 13
        _ -> 1
      end

    {:ok, first_date} = Date.new(year, month, starter_day)
    starter_wday = Date.day_of_week(first_date)

    # Scheduled wday is the number of wday related to scheduled weekday.
    scheduled_wday = weekday |> day_to_wday

    # Finding the day difference between the starting wday and the scheduled one.
    # 1 week has 7 days, it is basically like base 7 calculation.
    # We find the wday difference between the starter and the scheduled one.
    # Let 8 be subtracted by that number, if the result is more than 7, we
    # rotate it by subtracting it by 7.
    diff = 8 - (starter_wday - scheduled_wday)

    scheduled_wday =
      case diff > 7 do
        true -> diff - 7
        false -> diff
      end

    # Second, third, fourth weeks just add the number by
    # multiplication of 7. Teenth starts with 12. Last naively starts with 21.
    day = scheduled_wday + Map.get(days_adder(), schedule)

    # Just in case the day is not the last wday of the month, just add it by 7.
    calculated_day =
      cond do
        schedule == :last && Date.days_in_month(first_date) >= day + 7 ->
          day + 7

        true ->
          day
      end

    {year, month, calculated_day}
  end

  defp wday_mapping, do: ~w<monday tuesday wednesday thursday friday saturday sunday>a
  defp day_to_wday(wday), do: Enum.find_index(wday_mapping(), &(&1 == wday)) + 1
  defp days_adder, do: %{first: 0, second: 7, third: 14, fourth: 21, teenth: 12, last: 21}
end
