defmodule Watcher do
  use GenServer

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def watch(mod, f, args \\ []) do
    GenServer.cast(__MODULE__, {:watch, mod, f, args})
  end

  def init(_) do
    opts = [dirs: [Path.absname("lib")], latency: 0]
    {:ok, pid} = FileSystem.start_link(opts)
    FileSystem.subscribe(pid)
    {:ok, %{to_run: nil}}
  end

  def handle_cast({:watch, mod, f, args}, state) do
    to_run = {mod, f, args}
    {compile_result, _} = try_compile()
    if compile_result != :error, do: try_run(mod, f, args)
    {:noreply, %{state | to_run: to_run}}
  end

  def handle_info({:file_event, _pid, {_path, _event}}, %{to_run: to_run} = state) do
    try_it(to_run)

    {:noreply, state}
  end

  defp try_it({mod, f, args}) do
    with {:ok, compile_result} <- try_compile(),
         {:ok, _} <-
           (if compile_result == :ok do
              try_run(mod, f, args)
            end),
         do: nil
  end

  defp try_it(nil), do: nil

  defp try_compile() do
    run_in_task(&IEx.Helpers.recompile/0)
  end

  defp try_run(mod, f, args) do
    run_in_task(fn ->
      try do
        result = apply(mod, f, args)
        IO.puts(:stdio, IEx.color(:eval_result, inspect(result, IEx.inspect_opts())))
        {:ok, result}
      catch
        e ->
          IO.puts("Error while running: #{e}")
          {:error, e}
      end
    end)
  end

  @spec run_in_task((() -> any)) :: nil | {:exit, any} | {:ok, any}
  def run_in_task(f) do
    task = Task.Supervisor.async_nolink(Advent2021.TaskSupervisor, f)
    result = Task.yield(task)
    Task.shutdown(task)

    result
  end
end
