import AOC

aoc 2021, 5 do
  def input do
    input_stream()
    |> Enum.map(&parse/1)
  end

  def parse(line) do
    [from, to] = String.split(line, " -> ")
    [x1, y1] = String.split(from, ",")
    [x2, y2] = String.split(to, ",")

    {{String.to_integer(x1), String.to_integer(y1)},
     {String.to_integer(x2), String.to_integer(y2)}}
  end

  def p1 do
    input()
    |> Enum.filter(&is_nondiagonal/1)
    |> Enum.flat_map(&enumerate_positions/1)
    |> count_overlapping()
  end

  defp is_nondiagonal({{x1, y1}, {x2, y2}}) do
    x1 == x2 || y1 == y2
  end

  def enumerate_positions({{x1, y1}, {x2, y2}} = line) do
    if is_nondiagonal(line) do
      for x <- x1..x2, y <- y1..y2, do: {x, y}
    else
      direction = trunc((x2 - x1) / (y2 - y1))
      for x <- x1..x2, do: {x, y1 + direction * (x - x1)}
    end
  end

  def count_overlapping(positions) do
    positions
    |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
    |> Map.values()
    |> Enum.count(&(&1 >= 2))
  end

  def p2 do
    input()
    |> Enum.flat_map(&enumerate_positions/1)
    |> count_overlapping()
  end
end
