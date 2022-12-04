defmodule DayFour do
  @input_path "input.txt"

  defp get_input() do
    @input_path
    |> File.read!()
    |> String.split("\r\n")
    |> Enum.map(&parse_sections/1)
  end

  defp part_one(data) do
    Enum.reduce(data, 0, fn [left_range, right_range], full_overlap_sections ->
      full_overlap_sections + if is_fully_overlapping(left_range, right_range), do: 1, else: 0
    end)
  end

  defp part_two(data) do
    Enum.reduce(data, 0, fn [left_range, right_range], overlap_sections ->
      overlap_sections + if is_overlapping(left_range, right_range), do: 1, else: 0
    end)
  end

  defp parse_sections(pair) do
    pair
    |> String.split(",", trim: true)
    |> Enum.map(fn section_range ->
      section_range
      |> String.split("-", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end

  defp is_fully_overlapping([left_start, left_end], [right_start, right_end]) do
    (left_start >= right_start and left_end <= right_end) or
      (right_start >= left_start and right_end <= left_end)
  end

  defp is_overlapping([left_start, left_end], [right_start, right_end]) do
    Enum.max([left_start, right_start]) <= Enum.min([left_end, right_end])
  end

  def run() do
    data = get_input()
    IO.puts("Part one: #{part_one(data)}.")
    IO.puts("Part two: #{part_two(data)}.")
  end
end

DayFour.run()
