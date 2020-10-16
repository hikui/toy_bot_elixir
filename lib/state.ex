defmodule ToyBot.Position do
  defstruct x: 0, y: 0
end

defmodule ToyBot.State do
  @facing [:east, :south, :west, :north]

  alias ToyBot.{State, Position}

  defstruct board_size: 0, bot_pos: nil, facing: nil

  def rotate(state = %State{facing: current_facing}, rotate_direction) do
    index = Enum.find_index(@facing, &(&1 == current_facing))

    next_index =
      case rotate_direction do
        :left -> rem(index - 1 + 4, 4)
        :right -> rem(index + 1, 4)
        _ -> index
      end

    %State{state | facing: Enum.at(@facing, next_index)}
  end

  def next_position(state = %State{bot_pos: pos, facing: facing}) do
    %Position{x: x, y: y} = pos

    next_pos =
      case facing do
        :east -> %Position{pos | x: x + 1}
        :west -> %Position{pos | x: x - 1}
        :north -> %Position{pos | y: y + 1}
        :south -> %Position{pos | y: y - 1}
        _ -> pos
      end

    # Make sure it's valid
    next_pos =
      if is_position_valid?(state, next_pos) do
        next_pos
      else
        pos
      end

    %State{state | bot_pos: next_pos}
  end

  def place(state, pos = %ToyBot.Position{}, facing) do
    if is_position_valid?(state, pos) and is_facing_valid?(facing) do
      %State{state | bot_pos: pos, facing: facing}
    else
      state
    end
  end

  def is_state_valid?(state = %State{bot_pos: pos, facing: facing}) do
    pos != nil and facing != nil and is_position_valid?(state, pos) and is_facing_valid?(facing)
  end

  defp is_position_valid?(%State{board_size: size}, pos = %ToyBot.Position{}) do
    pos.x >= 0 and pos.y >= 0 and pos.x <= size - 1 and pos.y <= size - 1
  end

  defp is_facing_valid?(facing) do
    Enum.find(@facing, &(&1 == facing)) != nil
  end
end
