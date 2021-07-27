defmodule GenReport.HoursPerMonth do
  @moduledoc """
  This module provides a function to generate a report of worked hours per person, per month and per year
  in a company
  """

  alias GenReport.Parser

  def build(file, list) do
    list_months =
      file
      |> generate_list_months()

    list =
      list
      |> report_acc(list_months)

    file
    |> Parser.parse_file()
    |> Enum.reduce(list, fn line, report -> sum_value(line, report) end)
  end

  defp sum_value([name, hours, _, month, _], %{} = report) do
    list_month = Map.put(report[name], month, report[name][month] + hours)

    %{report | name => list_month}
  end

  defp report_acc(list, list_month) do
    list
    |> Enum.into(%{}, fn l -> {l, Enum.into(list_month, %{}, &{&1, 0})} end)
  end

  defp generate_list_months(file) do
    file
    |> Parser.parse_file()
    |> Enum.map(fn [_name, _hours, _day, month, _year] -> month end)
    |> Enum.uniq()
  end
end
