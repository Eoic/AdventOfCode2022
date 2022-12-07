defmodule DaySix do
  @input_path "input.txt"

  defp get_input() do
    @input_path
    |> File.read!()
    |> String.split("", trim: true)
  end

  defp part_one(data), do: get_position(data, 4)

  defp part_two(data), do: get_position(data, 14)

  defp get_position(data, window_size) do
    Enum.reduce_while(0..(length(data) - window_size - 1), 0, fn index, _ ->
      packet = Enum.slice(data, index, window_size)

      if Enum.uniq(packet) === packet,
        do: {:halt, index + window_size},
        else: {:cont, index}
    end)
  end

  def run() do
    data = get_input()
    IO.puts("Part one: #{part_one(data)}.")
    IO.puts("Part two: #{part_two(data)}.")
  end
end

DaySix.run()
