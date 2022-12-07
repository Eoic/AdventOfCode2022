defmodule DaySeven do
  @input_path "input.txt"
  @total_space 70_000_000
  @required_space 30_000_000

  defp get_input() do
    {_, history} =
      @input_path
      |> File.read!()
      |> String.split("\r\n")
      |> Enum.split(1)

    history
  end

  defp part_one(data) do
    data
    |> collect_paths(["."], %{})
    |> sum_sizes()
    |> Enum.filter(&(&1 <= 100_000))
    |> Enum.sum()
  end

  defp part_two(data) do
    sizes =
      data
      |> collect_paths(["."], %{})
      |> sum_sizes()
      |> Enum.sort()

    free_space = @total_space - Enum.at(sizes, -1)
    Enum.find(sizes, &(&1 + free_space >= @required_space))
  end

  defp collect_paths([], current_path, paths), do: paths

  defp collect_paths([line | history], current_path, paths) do
    cond do
      line === "$ ls" ->
        collect_paths(history, current_path, paths)

      line === "$ cd .." ->
        collect_paths(history, List.delete_at(current_path, length(current_path) - 1), paths)

      String.starts_with?(line, "$ cd ") ->
        directory = String.split(line, " ", trim: true) |> Enum.at(2)
        collect_paths(history, current_path ++ [directory], paths)

      Regex.match?(~r/dir \w+/, line) ->
        directory = String.split(line, " ", trim: true) |> Enum.at(1)
        path_info = Enum.join(current_path, "/") <> "/" <> directory
        paths_updated = Map.update(paths, path_info, 0, fn size_total -> size_total end)
        collect_paths(history, current_path, paths_updated)

      Regex.match?(~r/\d+ \w+[\.]?\w*/, line) ->
        [size, _] = String.split(line, " ", trim: true)
        path_info = Enum.join(current_path, "/")

        paths_updated =
          Map.update(paths, path_info, String.to_integer(size), fn size_total ->
            size_total + String.to_integer(size)
          end)

        collect_paths(history, current_path, paths_updated)
    end
  end

  defp sum_sizes(sizes) do
    keys = Map.keys(sizes)

    Enum.map(keys, fn path ->
      Enum.reduce(keys, 0, fn key, sum_total ->
        cond do
          String.starts_with?(key, path) -> sum_total + Map.get(sizes, key)
          true -> sum_total
        end
      end)
    end)
  end

  def run() do
    data = get_input()
    IO.puts("Part one: #{part_one(data)}.")
    IO.puts("Part two: #{part_two(data)}.")
  end
end

DaySeven.run()
