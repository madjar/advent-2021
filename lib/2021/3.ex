import AOC

aoc 2021, 3 do
  def input do
    input_stream()
    |> Stream.map(&String.to_charlist/1)
  end

  def p1 do
    [epsilon, gamma] =
      input()
      |> Enum.to_list()
      |> List.zip()
      |> Enum.map(fn position ->
        counts =
          position
          |> Tuple.to_list()
          |> counter()

        {least(counts), most(counts)}
      end)
      |> List.zip()
      |> Enum.map(&Tuple.to_list/1)
      |> Enum.map(&to_string/1)
      |> Enum.map(&String.to_integer(&1, 2))

    epsilon * gamma
  end

  def p2 do
    inp = input()
    oxygen = select_for_bit(inp, 0, &most/1)
    co2 = select_for_bit(inp, 0, &least/1)
    oxygen * co2
  end

  def counter(list) do
    list
    |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
  end

  def _least_most(counter, f, default) do
    if Map.fetch(counter, 48) == Map.fetch(counter, 49) do
      default
    else
      counter
      |> Map.to_list()
      |> f.(&elem(&1, 1))
      |> then(&elem(&1, 0))
    end
  end

  def least(counter) do
    _least_most(counter, &Enum.min_by/2, 48)
  end

  def most(counter) do
    _least_most(counter, &Enum.max_by/2, 49)
  end

  def select_for_bit(numbers, bit, function) do
    winning =
      numbers
      |> Enum.map(&Enum.at(&1, bit))
      |> then(&counter/1)
      |> then(function)

    candidates = numbers |> Enum.filter(&(Enum.at(&1, bit) == winning))

    case candidates do
      [result] -> result |> to_string() |> String.to_integer(2)
      _ -> select_for_bit(candidates, bit + 1, function)
    end
  end
end
