import AOC

aoc 2021, 8 do
  @display %{
    0 => "abcefg",
    1 => "cf",
    2 => "acdeg",
    3 => "acdfg",
    4 => "bcdf",
    5 => "abdfg",
    6 => "abdefg",
    7 => "acf",
    8 => "abcdefg",
    9 => "abcdfg"
  }
  @all "abcdefg" |> String.graphemes()

  def input do
    input_stream()
    |> Stream.map(&parse_line/1)
  end

  def parse_line(line) do
    [patterns, value] = String.split(line, " | ")
    {parse_digits(patterns), parse_digits(value)}
  end

  defp parse_digits(digits) do
    digits
    |> String.split()

    # |> Enum.map(&String.graphemes/1)
  end

  def p1 do
    input()
    |> Stream.map(fn {_, value} ->
      value
      |> Enum.count(fn digit ->
        Enum.member?([2, 4, 3, 7], String.length(digit))
      end)
    end)
    |> Enum.sum()
  end

  def p2 do
    input()
    |> Stream.map(&solve_entry/1)

    # |> Enum.at(0)
    |> Enum.sum()
  end

  def example do
    "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"
    |> parse_line()
    |> solve_entry()
  end

  def solve_entry({patterns, value}) do
    possible = @all |> Enum.map(&{&1, @all}) |> Map.new()

    possible =
      patterns
      |> Enum.reduce(possible, fn pat, possible ->
        candidates =
          @display
          |> Map.values()
          |> Enum.filter(&(String.length(&1) == String.length(pat)))

        case candidates do
          [single] ->
            in_pattern = pat |> String.graphemes() |> MapSet.new()

            possible
            |> Map.map(fn {l, poss} ->
              if MapSet.member?(in_pattern, l) do
                poss |> Enum.filter(&String.contains?(single, &1))
              else
                poss |> Enum.filter(&(!String.contains?(single, &1)))
              end
            end)

          _ ->
            possible
        end
      end)

    value
    |> Enum.map(fn pat ->
      pat
      |> String.graphemes()
      |> Enum.map(fn l -> Map.fetch!(possible, l) end)

      # Here, we remove ambiguity that doesn't matter
      |> Enum.group_by(& &1)
      |> Enum.flat_map(fn
        {value, permutations} ->
          if Enum.count(value) == Enum.count(permutations) do
            Enum.map(value, &[&1])
          else
            [value]
          end
      end)
      |> cartesian()
      |> Enum.flat_map(fn possible_digit ->
        segments =
          possible_digit
          |> Enum.sort()
          |> Enum.join()

        @display
        |> Enum.filter(fn {_di, segs} -> segs == segments end)
        |> Enum.map(&elem(&1, 0))
      end)
      |> ensure_one()
      |> Integer.to_string()
    end)
    |> Enum.join()
    |> String.to_integer()
  end

  def cartesian([x]), do: x |> Enum.map(fn a -> [a] end)

  def cartesian([head | tail]) do
    cartesian(tail)
    |> Enum.flat_map(fn r -> Enum.map(head, fn h -> [h] ++ r end) end)
  end

  defp ensure_one([x]), do: x
end
