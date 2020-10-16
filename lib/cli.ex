defmodule ToyBot.CLI do
  alias ToyBot.{State, Position}

  @facing_map %{east: "EAST", south: "SOUTH", west: "WEST", north: "NORTH"}

  def main(args \\ []) do
    {:ok, pid} = ToyBot.start_link(5)
    IO.puts("You can start inputting commands")
    input_loop(pid)
  end

  defp input_loop(pid) do
    cmd = IO.read(:stdio, :line) |> String.trim()
    process_command(pid, cmd)
    input_loop(pid)
  end

  defp process_command(pid, _place = "PLACE" <> xyf) do
    [x, y, facing] = String.split(xyf, ",") |> Enum.map(&String.trim(&1))
    {x, _} = Integer.parse(x)
    {y, _} = Integer.parse(y)
    facing = str_to_facing(facing)
    ToyBot.place(pid, %Position{x: x, y: y}, facing)
  end

  defp process_command(pid, "LEFT") do
    case ToyBot.get_state(pid) |> State.is_state_valid?() do
      true -> ToyBot.rotate(pid, :left)
      false -> :noop
    end
  end

  defp process_command(pid, "RIGHT") do
    case ToyBot.get_state(pid) |> State.is_state_valid?() do
      true -> ToyBot.rotate(pid, :right)
      false -> :noop
    end
  end

  defp process_command(pid, "MOVE") do
    case ToyBot.get_state(pid) |> State.is_state_valid?() do
      true -> ToyBot.move(pid)
      false -> :noop
    end
  end

  defp process_command(pid, "REPORT") do
    state = ToyBot.get_state(pid)

    case State.is_state_valid?(state) do
      true ->
        %State{bot_pos: %Position{x: x, y: y}, facing: facing} = state
        IO.puts("#{x}, #{y}, #{Map.get(@facing_map, facing)}")

      false ->
        IO.puts("State invalid")
    end
  end

  defp process_command(_pid, _other), do: IO.puts("Invalid command")

  defp str_to_facing(str) do
    Map.to_list(@facing_map)
    |> Enum.find_value(nil, fn {k, v} ->
      if v == str, do: k
    end)
  end
end
