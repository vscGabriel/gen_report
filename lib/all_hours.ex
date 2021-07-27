defmodule GenReport.AllHours do
  @moduledoc """
  This module provides a function to generate a report of worked hours per person, per month and per year
  in a company
  """
  alias GenReport.Parser

  def build(file, list) do
    list = report_acc(list)

    file
    |> Parser.parse_file()
    |> Enum.reduce(list, fn line, report -> sum_value(line, report) end)
  end

  defp sum_value([name, hours, _, _, _], report) do
    Map.put(report, name, report[name] + hours)
  end

  defp report_acc(list) do
    list
    |> Enum.into(%{}, &{&1, 0})
  end
end
