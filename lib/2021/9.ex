import AOC

aoc 2021, 9 do
  def input() do
    input_stream()
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
      |> Enum.with_index()
      |> Enum.map(fn {loc, x} -> {{x, y}, loc} end)
    end)
    |> Map.new()
  end

  def p1 do
    floor = input()

    floor
    |> Map.filter(&is_low_point(&1, floor))
    |> Enum.map(fn {_, loc} -> loc + 1 end)
    |> Enum.sum()
  end

  @adjacent [{0, 1}, {0, -1}, {1, 0}, {-1, -0}]

  def adjacents({x, y}) do
    Enum.map(@adjacent, fn {dx, dy} ->
      {x + dx, y + dy}
    end)
  end

  def is_low_point({pos, loc}, floor) do
    adjacents(pos)
    |> Enum.map(&Map.get(floor, &1))
    |> Enum.all?(&(&1 > loc))
  end

  def p2 do
    floor = input()

    floor
    |> Map.filter(&is_low_point(&1, floor))
    |> Enum.map(fn {pos, _loc} -> pos end)
    |> Enum.map(&find_basin(&1, floor))
    |> Enum.sort(:desc)
    |> Enum.take(3)
    |> Enum.product()
  end

  def find_basin(pos, floor) do
    do_find_basin([pos], MapSet.new(), floor)
  end

  def do_find_basin([], _seen, _floor) do
    0
  end

  def do_find_basin([pos | rest], seen, floor) do
    if MapSet.member?(seen, pos) do
      do_find_basin(rest, seen, floor)
    else
      new_seen = MapSet.put(seen, pos)

      case Map.get(floor, pos) do
        nil ->
          do_find_basin(rest, new_seen, floor)

        9 ->
          do_find_basin(rest, new_seen, floor)

        _ ->
          1 + do_find_basin(adjacents(pos) ++ rest, new_seen, floor)
      end
    end
  end
end
