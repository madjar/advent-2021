import AOC

aoc 2021, 10 do
  def input do
    input_stream()
    |> Stream.map(&String.graphemes/1)
  end

  @chars ~w"() [] {} <>"
         |> Map.new(fn pair -> pair |> String.graphemes() |> List.to_tuple() end)

  @scores %{")" => 3, "]" => 57, "}" => 1197, ">" => 25137}

  def p1 do
    input()
    |> Stream.map(&check_line/1)
    |> Stream.flat_map(fn
      {:corrupted, char} -> [char]
      _ -> []
    end)
    |> Stream.map(&Map.get(@scores, &1))
    |> Enum.sum()
  end

  def check_line(input, stack \\ [])

  def check_line([], []), do: :ok
  def check_line([], stack), do: {:incomplete, stack}

  def check_line([char | rest], [char | rest_stack]),
    do: check_line(rest, rest_stack)

  def check_line([char | rest], stack) do
    case(Map.get(@chars, char)) do
      nil ->
        {:corrupted, char}

      closing_char ->
        check_line(rest, [closing_char | stack])
    end
  end

  def p2 do
    input()
    |> Stream.map(&check_line/1)
    |> Stream.flat_map(fn
      {:incomplete, rest} -> [rest]
      _ -> []
    end)
    |> Stream.map(&score_incomplete/1)
    |> Enum.to_list()
    |> median()
  end

  @autocomplete_scores %{")" => 1, ">" => 4, "]" => 2, "}" => 3}

  def score_incomplete(l, acc \\ 0)
  def score_incomplete([], acc), do: acc

  def score_incomplete([char | rest], acc) do
    score_incomplete(rest, acc * 5 + Map.fetch!(@autocomplete_scores, char))
  end

  def median(list) do
    Enum.at(Enum.sort(list), div(Enum.count(list), 2))
  end
end
