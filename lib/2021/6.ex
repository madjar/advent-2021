import AOC

aoc 2021, 6 do
  def input do
    input_string()
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def p1 do
    input()
    |> compact()
    |> Stream.iterate(&step/1)
    |> Enum.at(80)
    |> Map.values()
    |> Enum.sum()
  end

  # def step(list) when is_list(list) do
  #   list
  #   |> Enum.flat_map(fn
  #     0 -> [6, 8]
  #     n -> [n - 1]
  #   end)
  # end

  def step(compacted) when is_map(compacted) do
    compacted
    |> Enum.flat_map(fn
      {0, count} -> [{6, count}, {8, count}]
      {n, count} -> [{n - 1, count}]
    end)
    |> Enum.reduce(%{}, fn {n, count}, acc -> Map.update(acc, n, count, &(&1 + count)) end)
    |> IO.inspect()
  end

  def compact(list) do
    list
    |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
  end

  def p2 do
    input()
    |> compact()
    |> Stream.iterate(&step/1)
    |> Enum.at(256)
    |> Map.values()
    |> Enum.sum()
  end
end
