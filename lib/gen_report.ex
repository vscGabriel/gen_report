defmodule GenReport do
  @moduledoc """
    This module provides a function to generate a report of worked hours per person, per month and per year
    in a company
  """
  alias GenReport.{AllHours, HoursPerMonth, HoursPerYear, Parser}

  def build(filename) do
    list =
      filename
      |> Parser.parse_file()
      |> gen_list_name()

    all_hours =
      filename
      |> AllHours.build(list)

    hours_per_month =
      filename
      |> HoursPerMonth.build(list)

    hours_per_year =
      filename
      |> HoursPerYear.build(list)

    %{
      all_hours: all_hours,
      hours_per_month: hours_per_month,
      hours_per_year: hours_per_year
    }
  end

  defp gen_list_name(list) do
    list
    |> Enum.map(fn [head | _tail] -> head end)
    |> Enum.uniq()
  end
end
