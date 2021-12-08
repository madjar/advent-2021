import AOC

aoc 2021, 4 do
  def input do
    [numbers | boards] = input_string() |> String.trim() |> String.split("\n\n")

    {numbers
     |> String.split(","),
     boards
     |> Enum.map(fn b ->
       b
       |> String.split("\n")
       |> Enum.map(&String.split/1)
     end), nil}
  end

  def p1 do
    input()
    |> Stream.iterate(&draw/1)
    |> Enum.find(fn {_, boards, _} -> find_winning(boards) end)
    |> then(&score/1)
  end

  def draw({[number | numbers], boards, _}) do
    {numbers,
     boards
     |> Enum.map(fn board ->
       Enum.map(
         board,
         &Enum.map(&1, fn value ->
           if value == number do
             :marked
           else
             value
           end
         end)
       )
     end), number}
  end

  defp has_winning_row(board) do
    Enum.find(board, fn row ->
      Enum.all?(row, &(&1 == :marked))
    end)
  end

  def board_is_winning(board) do
    columns = board |> Enum.zip() |> Enum.map(&Tuple.to_list/1)
    has_winning_row(board) || has_winning_row(columns)
  end

  def find_winning(boards) do
    boards
    |> Enum.find(&board_is_winning/1)
  end

  def score({_, boards, last_number}) do
    board = find_winning(boards)

    sum =
      board
      |> List.flatten()
      |> Stream.filter(&(&1 != :marked))
      |> Stream.map(&String.to_integer/1)
      |> Enum.sum()

    sum * String.to_integer(last_number)
  end

  def p2 do
    input()
    |> Stream.iterate(&draw_and_drop_winning/1)
    |> Enum.find(fn {_, boards, _} -> Enum.count(boards) == 1 && find_winning(boards) end)
    |> then(&score/1)
  end

  def draw_and_drop_winning(state) do
    {numbers, boards, last_number} = draw(state)

    {numbers,
     if Enum.count(boards) > 1 do
       boards
       |> Enum.filter(&(!board_is_winning(&1)))
     else
       boards
     end, last_number}
  end
end
