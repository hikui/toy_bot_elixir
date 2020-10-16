defmodule ToyBot do
  use GenServer

  alias ToyBot.{State, Position}

  def rotate(pid, direction) do
    GenServer.cast(pid, {:rotate, direction})
  end

  def move(pid) do
    GenServer.cast(pid, :move)
  end

  def place(pid, position = %Position{}, facing) do
    GenServer.cast(pid, {:place, position, facing})
  end

  def get_state(pid) do
    GenServer.call(pid, :get_state)
  end

  def start_link(board_size) do
    GenServer.start_link(__MODULE__, board_size)
  end

  @impl true
  def init(board_size) do
    # Initialize board state
    board = %State{board_size: board_size}
    {:ok, board}
  end

  @impl true
  def handle_call(:get_state, _from, state) do
    {:reply, state, state}
  end

  @impl true
  def handle_cast({:rotate, direction}, state = %State{}) do
    next_state = State.rotate(state, direction)
    {:noreply, next_state}
  end

  @impl true
  def handle_cast(:move, state = %State{}) do
    next_state = State.next_position(state)
    {:noreply, next_state}
  end

  @impl true
  def handle_cast({:place, position, facing}, state = %State{}) do
    next_state = State.place(state, position, facing)
    {:noreply, next_state}
  end
end
