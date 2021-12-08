import AOC

aoc 2021, 2 do
  def input do
    input_stream()
    |> Stream.map(&String.split/1)
    |> Stream.map(fn [command, unit] -> {String.to_atom(command), String.to_integer(unit)} end)
  end

  def p1 do
    input()
    |> Enum.reduce({0, 0}, fn {command, unit}, {pos, depth} ->
      case command do
        :forward -> {pos + unit, depth}
        :down -> {pos, depth + unit}
        :up -> {pos, depth - unit}
      end
    end)
    |> then(fn {a, b} -> a * b end)
  end

  def p2 do
    input()
    |> Enum.reduce({0, 0, 0}, fn {command, unit}, {pos, depth, aim} ->
      case command do
        :forward -> {pos + unit, depth + aim * unit, aim}
        :down -> {pos, depth, aim + unit}
        :up -> {pos, depth, aim - unit}
      end
    end)
    |> then(fn {a, b, _} -> a * b end)
  end
end
