defmodule DayOne do
  @input_path "input.txt"

  def get_input do
    @input_path
    |> File.read!()
    |> String.split(~r/\R{2,}/)
    |> Enum.map(fn calorie_groups ->
      calorie_groups
      |> String.split(~r/\R/)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  def part_one(data) do
    data
    |> Enum.map(&Enum.sum/1)
    |> Enum.max()
  end

  def part_two(data) do
    data
    |> Enum.map(&Enum.sum/1)
    |> Enum.sort()
    |> Enum.take(-3)
    |> Enum.sum()
  end

  def run do
    data = get_input()
    IO.puts("Part one: #{part_one(data)}.")
    IO.puts("Part two: #{part_two(data)}.")
  end
end

DayOne.run()
