defmodule DayThree do
  @input_path "input.txt"
  @lowercase_label_offset 96
  @uppercase_label_offset 38

  def get_input() do
    backpacks =
      @input_path
      |> File.read!()
      |> String.split("\r\n")
      |> Enum.map(&String.split(&1, "", trim: true))

    [backpacks, create_priority_map()]
  end

  def part_one([backpacks, priorities]) do
    Enum.reduce(backpacks, 0, fn (items, priorities_sum) ->
      priorities_sum +
        (items
         |> Enum.split(div(length(items), 2))
         |> Tuple.to_list()
         |> find_common_item()
         |> (&Map.get(priorities, &1)).())
    end)
  end

  def part_two([backpacks, priorities]) do
    backpacks
    |> Enum.chunk_every(3, 3)
    |> Enum.reduce(0, fn (backpack_group, priorities_sum_total) ->
      priorities_sum_total + Map.get(priorities, find_common_item(backpack_group))
    end)
  end

  defp find_common_item([first_backpack | rest_backpacks]) do
    rest_backpacks
    |> Enum.reduce(MapSet.new(first_backpack), fn (next_backpack, common_items) ->
      MapSet.intersection(common_items, MapSet.new(next_backpack))
    end)
    |> Enum.to_list()
    |> Enum.at(0)
  end

  defp create_priority_map() do
    [[?a..?z, @lowercase_label_offset], [?A..?Z, @uppercase_label_offset]]
    |> Enum.reduce(%{}, fn ([charlist_generator, offset], priorities_acc_total) ->
      Enum.reduce(charlist_generator, priorities_acc_total, fn (token, priorities_acc) ->
        Map.put(priorities_acc, <<token::utf8>>, token - offset)
      end)
    end)
  end

  def run() do
    data = get_input()
    IO.puts("Part one: #{part_one(data)}.")
    IO.puts("Part two: #{part_two(data)}.")
  end
end

DayThree.run()
