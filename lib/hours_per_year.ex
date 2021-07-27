defmodule GenReport.HoursPerYear do
  @moduledoc """
  This module provides a function to generate a report of worked hours per person, per month and per year
  in a company
  """

  alias GenReport.Parser

  def build(file, list) do
    list_years =
      file
      |> generate_list_years()

    list =
      list
      |> report_acc(list_years)

    file
    |> Parser.parse_file()
    |> Enum.reduce(list, fn line, report -> sum_value(line, report) end)
  end

  defp sum_value([name, hours, _, _, year], %{} = report) do
    list_years = Map.put(report[name], year, report[name][year] + hours)

    %{report | name => list_years}
  end

  defp report_acc(list, list_years) do
    list
    |> Enum.into(%{}, fn l -> {l, Enum.into(list_years, %{}, &{&1, 0})} end)
  end

  defp generate_list_years(file) do
    file
    |> Parser.parse_file()
    |> Enum.map(fn [_name, _hours, _day, _month, year] -> year end)
    |> Enum.uniq()
  end
end
