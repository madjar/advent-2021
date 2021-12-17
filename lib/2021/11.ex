import AOC

aoc 2021, 11 do
  def input() do
    input_stream() |> parse()
  end

  def parse(i) do
    i
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

  @adjacent [{0, 1}, {0, -1}, {1, 0}, {-1, 0}, {1, 1}, {1, -1}, {-1, 1}, {-1, -1}]

  def adjacents({x, y}) do
    Enum.map(@adjacent, fn {dx, dy} ->
      {x + dx, y + dy}
    end)
  end

  def p1 do
    input()
    |> iterate_step()
    |> Enum.at(100)
    |> elem(1)
  end

  def iterate_step(map) do
    Stream.iterate({map, 0}, &step_with_count/1)
  end

  def step_with_count({map, count}) do
    {new_map, new_count} = step(map)
    {new_map, count + new_count}
  end

  def inc(:flashed), do: :flashed
  def inc(n), do: n + 1

  def step(map) do
    map
    |> Map.map(fn {_, energy} -> inc(energy) end)
    |> flash_until_done()
    |> count_and_reset()
  end

  def flash_until_done(map) do
    flashed =
      map
      |> Map.filter(fn {_, value} -> value != :flashed && value > 9 end)

    if flashed != %{} do
      map_with_flashed =
        map
        |> Map.map(fn {_, value} ->
          if value > 9 do
            :flashed
          else
            value
          end
        end)

      flashed
      |> Map.keys()
      |> Enum.flat_map(&adjacents/1)
      |> Enum.reduce(map_with_flashed, fn pos, acc ->
        update_existing(acc, pos, &inc/1)
      end)
      |> flash_until_done()
    else
      map
    end
  end

  def count_and_reset(map) do
    count = map |> Enum.count(fn {_, value} -> value == :flashed end)

    reset =
      map
      |> Map.map(fn {_, value} ->
        if value == :flashed do
          0
        else
          value
        end
      end)

    {reset, count}
  end

  def p2 do
    input()
    |> iterate_step()
    |> Enum.find_index(fn {map, _} ->
      map
      |> Map.values()
      |> Enum.all?(&(&1 == 0))
    end)
  end

  defp update_existing(map, key, fun) do
    case map do
      %{^key => old} -> %{map | key => fun.(old)}
      %{} -> map
    end
  end

  def print({map, _count}), do: print(map)

  def print(map) do
    maxX = Enum.map(map, fn {{x, _}, _} -> x end) |> Enum.max()
    maxY = Enum.map(map, fn {{_, y}, _} -> y end) |> Enum.max()

    IO.puts("========")

    Enum.map(0..maxY, fn y ->
      Enum.map(0..maxX, fn x ->
        case Map.fetch!(map, {x, y}) do
          0 -> IO.ANSI.bright() <> "0" <> IO.ANSI.reset()
          char -> Integer.to_string(char)
        end
      end)
      |> Enum.join()
    end)
    |> Enum.join("\n")
    |> IO.puts()
  end

  def example do
    "5483143223
    2745854711
    5264556173
    6141336146
    6357385478
    4167524645
    2176841721
    6882881134
    4846848554
    5283751526"
    |> String.split()
    |> parse()
    |> iterate_step()
    |> Enum.at(100)
    |> elem(1)
  end
end
