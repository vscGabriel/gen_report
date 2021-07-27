defmodule GenReport do
  @moduledoc """
    This module provides a function to generate a report of worked hours per person, per month and per year
    in a company
  """
  alias GenReport.Parser

  @people [
    "Cleiton",
    "Daniele",
    "Danilo",
    "Diego",
    "Giuliano",
    "Jakeliny",
    "Joseph",
    "Mayk",
    "Rafael",
    "Vinicius"
  ]

  @months [
    "janeiro",
    "fevereiro",
    "março",
    "abril",
    "maio",
    "junho",
    "julho",
    "agosto",
    "setembro",
    "outubro",
    "novembro",
    "dezembro"
  ]

  @years [
    2016,
    2017,
    2018,
    2019,
    2020
  ]

  def build(filename) do
    filename
    |> Parser.parse_file()
    |> Enum.reduce(report_acc(), fn data, report -> sum_values(data, report) end)
  end

  defp sum_values(
         [name, hours, _, month, year],
         %{
           "all_hours" => all_hours,
           "hours_per_month" => hours_per_month,
           "hours_per_year" => hours_per_year
         }
       ) do
    all_hours = Map.put(all_hours, name, all_hours[name] + hours)
    hours_per_month = Map.put(hours_per_month[name], month, hours_per_month[name][month] + hours)
    hours_per_year = Map.put(hours_per_year[name], year, hours_per_year[name][year] + year)

    %{
      "all_hours" => all_hours,
      "hours_per_month" => hours_per_month,
      "hours_per_year" => hours_per_year
    }
  end

  defp report_acc() do
    %{
      "all_hours" => generate_all_hours_map(),
      "hours_per_month" => generate_hours_per_month_map(),
      "hours_per_year" => generate_hours_per_year_map()
    }
  end

  defp generate_all_hours_map do
    @people
    |> Enum.into(%{}, fn elem -> {elem, 0} end)
  end

  defp generate_hours_per_month_map do
    @people
    |> Enum.into(%{}, fn elem -> {elem, create_month_hours()} end)
  end

  defp generate_hours_per_year_map do
    @people
    |> Enum.into(%{}, fn elem -> {elem, create_year_hours()} end)
  end

  defp create_year_hours do
    @years
    |> Enum.into(%{}, fn elem -> {elem, 0} end)
  end

  defp create_month_hours do
    @months
    |> Enum.into(%{}, fn elem -> {elem, 0} end)
  end
end
