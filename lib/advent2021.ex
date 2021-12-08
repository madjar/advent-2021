defmodule Advent2021 do
  @moduledoc """
  Documentation for `Advent2021`.
  """
  use Application

  def set_day(day) do
    Application.put_env(:advent_of_code_utils, :day, day)
  end

  def start(_type, _args) do
    :ok = Application.ensure_started(:file_system)

    children = [{Task.Supervisor, name: Advent2021.TaskSupervisor}, Watcher]

    opts = [strategy: :one_for_one, name: Advent2021.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def watch(f), do: watch(AOC.IEx.mod(), f)

  def watch(mod, f, args \\ []), do: Watcher.watch(mod, f, args)
end
