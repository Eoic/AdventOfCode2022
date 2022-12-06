defmodule DayFive do
  @input_path "input.txt"

  defp get_input() do
    [crates, commands] =
      @input_path
      |> File.read!()
      |> String.split("\r\n\r\n")

    {crates_parsed, positions} =
      crates
      |> String.split("", trim: true)
      |> Enum.chunk_every(3, 4)
      |> Enum.chunk_every(9)
      |> Enum.split(-1)

    column_count =
      positions
      |> Enum.at(0)
      |> Enum.at(-1)
      |> Enum.at(1)
      |> String.to_integer()

    [parse_crates(crates_parsed, column_count), parse_commands(commands), column_count]
  end

  defp part_one([crates, commands, column_count]) do
    commands
    |> Enum.reduce(crates, fn command, crates_current -> apply_command(command, crates_current, false) end)
    |> collect_message(column_count)
  end

  defp part_two([crates, commands, column_count]) do
    Enum.reduce(commands, crates, fn command, crates_current -> apply_command(command, crates_current, true) end)
    |> collect_message(column_count)
  end

  defp parse_crates(crates, column_count) do
    0..(length(crates) - 1)
    |> Enum.reduce(%{}, fn index, map_acc ->
      row = Enum.at(crates, index)

      1..column_count
      |> Enum.reduce(map_acc, fn position, map_acc_row ->
        element = Enum.at(row, position - 1) |> Enum.at(1)

        cond do
          element !== " " ->
            Map.update(map_acc_row, position, [element], fn elements -> [element | elements] end)

          true ->
            map_acc_row
        end
      end)
    end)
  end

  defp parse_commands(commands) do
    commands
    |> String.split("\r\n")
    |> Enum.map(fn row ->
      %{"count" => count, "from" => from, "to" => to} =
        Regex.named_captures(~r/move (?<count>\d+) from (?<from>\d+) to (?<to>\d+)/, row)

      %{
        "count" => String.to_integer(count),
        "from" => String.to_integer(from),
        "to" => String.to_integer(to)
      }
    end)
  end

  defp apply_command(%{"count" => count, "from" => from, "to" => to}, crates, bulk_move) do
    {source_stack_current, taken} = Enum.split(Map.get(crates, from), -count)

    crates
    |> Map.update!(to, fn stack -> stack ++ if bulk_move, do: taken, else: Enum.reverse(taken) end)
    |> Map.update!(from, fn _ -> source_stack_current end)
  end

  defp collect_message(crates, stack_count) do
    1..stack_count
    |> Enum.reduce([], fn position, message ->
      [Enum.take(Map.get(crates, position), -1) | message]
    end)
    |> Enum.reverse()
    |> Enum.join("")
  end

  def run() do
    data = get_input()
    IO.puts("Part one: #{part_one(data)}.")
    IO.puts("Part two: #{part_two(data)}.")
  end
end

DayFive.run()
