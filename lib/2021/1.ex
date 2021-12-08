import AOC

aoc 2021, 1 do
  def input do
    input_stream()
    |> Stream.map(&String.to_integer/1)
  end

  def p1 do
    input()
    |> Stream.chunk_every(2, 1, :discard)
    |> Enum.count(fn [a, b] -> a < b end)
  end

  def p2 do
    input()
    |> Stream.chunk_every(3, 1, :discard)
    |> Stream.map(&Enum.sum/1)
    |> Stream.chunk_every(2, 1, :discard)
    |> Enum.count(fn [a, b] -> a < b end)
  end
end
