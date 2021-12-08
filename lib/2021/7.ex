import AOC

aoc 2021, 7 do
  def input do
    input_string()
    |> String.trim()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
  end

  def p1 do
    input = input()
    width = Enum.max(input)

    0..width
    |> Stream.map(&cost_to_get_to(&1, input))
    |> Enum.min()
  end

  def cost_to_get_to(pos, list) do
    list
    |> Stream.map(fn crab -> abs(crab - pos) end)
    |> Enum.sum()
  end

  def real_cost_to_get_to(pos, list) do
    list
    |> Stream.map(fn crab ->
      distance = abs(crab - pos)
      floor(distance * (distance + 1) / 2)
    end)
    |> Enum.sum()
  end

  def p2 do
    input = input()
    width = Enum.max(input)

    0..width
    |> Stream.map(&real_cost_to_get_to(&1, input))
    |> Enum.min()
  end
end
