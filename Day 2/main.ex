defmodule DayTwo do
  @input_path "input.txt"
  @winning_selections %{A: "Z", B: "X", C: "Y"}
  @losing_selections %{A: "Y", B: "Z", C: "X"}
  @drawing_selections %{A: "X", B: "Y", C: "Z"}
  @selection_scores %{X: 1, Y: 2, Z: 3}

  def get_input() do
    @input_path
    |> File.read!()
    |> String.split("\r\n")
    |> Enum.map(&String.split(&1, " "))
  end

  def part_one(data) do
    sum_score(data, &transform_selection_noop/1)
  end

  def part_two(data) do
    sum_score(data, &transform_selection_guide/1)
  end

  def resolve_game(opponent_selection, owner_selection) do
    cond do
      Map.get(@winning_selections, String.to_atom(opponent_selection)) === owner_selection -> 0
      Map.get(@drawing_selections, String.to_atom(opponent_selection)) === owner_selection -> 3
      true -> 6
    end
  end

  def sum_score(data, transformer) do
    Enum.reduce(data, 0, fn ([opponent_selection, owner_selection], score) ->
      owner_selection = transformer.([opponent_selection, owner_selection])
      score + resolve_game(opponent_selection, owner_selection) + Map.get(@selection_scores, String.to_atom(owner_selection))
    end)
  end

  def transform_selection_guide([opponent_selection, owner_selection]) do
    case owner_selection do
      "X" -> Map.get(@winning_selections, String.to_atom(opponent_selection))
      "Y" -> Map.get(@drawing_selections, String.to_atom(opponent_selection))
      "Z" -> Map.get(@losing_selections, String.to_atom(opponent_selection))
    end
  end

  def transform_selection_noop([_, owner_selection]), do: owner_selection

  def run() do
    data = get_input()
    IO.puts("Part one: #{part_one(data)}.")
    IO.puts("Part two: #{part_two(data)}.")
  end
end

DayTwo.run()
