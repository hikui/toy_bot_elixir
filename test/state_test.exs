defmodule ToyBotTest.State do
  use ExUnit.Case
  doctest ToyBot

  alias ToyBot.{State, Position}

  test "move out of board lower edge" do
    state = %State{board_size: 5, bot_pos: %Position{x: 0, y: 0}, facing: :south}
    next_state = State.next_position(state)
    assert next_state.bot_pos == %Position{x: 0, y: 0}

    tate = %State{board_size: 5, bot_pos: %Position{x: 0, y: 0}, facing: :west}
    next_state = State.next_position(state)
    assert next_state.bot_pos == %Position{x: 0, y: 0}
  end

  test "move out of board upper edge" do
    state = %State{board_size: 5, bot_pos: %Position{x: 4, y: 0}, facing: :east}
    next_state = State.next_position(state)
    assert next_state.bot_pos == %Position{x: 4, y: 0}

    state = %State{board_size: 5, bot_pos: %Position{x: 0, y: 4}, facing: :north}
    next_state = State.next_position(state)
    assert next_state.bot_pos == %Position{x: 0, y: 4}
  end

  test "normal move" do
    state = %State{board_size: 5, bot_pos: %Position{x: 2, y: 2}, facing: :east}
    next_state = State.next_position(state)
    assert next_state.bot_pos == %Position{x: 3, y: 2}

    next_state = State.rotate(next_state, :right)
    next_state = State.next_position(next_state)
    assert next_state.bot_pos == %Position{x: 3, y: 1}
    assert next_state.facing == :south

    next_state = State.rotate(next_state, :right)
    next_state = State.next_position(next_state)
    assert next_state.bot_pos == %Position{x: 2, y: 1}
    assert next_state.facing == :west

    next_state = State.rotate(next_state, :right)
    next_state = State.next_position(next_state)
    assert next_state.bot_pos == %Position{x: 2, y: 2}
    assert(next_state.facing == :north)
  end
end
