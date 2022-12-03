defmodule DayThree do
  @input_path "input.txt"

  def get_input() do
    backpacks =
      @input_path
      |> File.read!()
      |> String.split("\r\n")
      |> Enum.map(&String.split(&1, "", trim: true))

    [backpacks, create_priority_map()]
  end

  def part_one([backpacks, priorities]) do
    sum_duplicate_priorities(backpacks, priorities)
  end

  def part_two([backpacks, priorities]) do
    backpacks
    |> Enum.chunk_every(3, 3)
    |> Enum.reduce(0, fn (backpack_group, sum) ->
      sum + Map.get(priorities, find_common_item(backpack_group), 0)
    end)
  end

  def sum_duplicate_priorities(backpacks, priorities) do
    Enum.reduce(backpacks, 0, fn items, sum_acc ->
      {left_compartment, right_compartment} = Enum.split(items, div(length(items), 2))
      unique_items = left_compartment -- right_compartment
      common_items = Enum.uniq(left_compartment -- unique_items)
      sum_acc + sum_priorities(common_items, priorities)
    end)
  end

  def sum_priorities(items, priorities) do
    Enum.reduce(items, 0, fn item, sum ->
      sum + Map.get(priorities, item, 0)
    end)
  end

  def find_common_item([first_backpack | rest_backpacks]) do
    rest_backpacks
    |> Enum.reduce(MapSet.new(first_backpack), fn (next_backpack, common_items) ->
      MapSet.intersection(common_items, MapSet.new(next_backpack))
    end)
    |> Enum.to_list()
    |> Enum.at(0)
  end

  def create_priority_map() do
    [[?a..?z, 96], [?A..?Z, 38]]
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
