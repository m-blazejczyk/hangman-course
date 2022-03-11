defmodule Hangman do
  alias Hangman.Impl.Game

  @type state :: :initializing | :won | :lost | :good_guess | :bad_guess | :already_used
  @type tally :: %{
          turns_left: integer,
          game_state: state,
          letters: list(String),
          used: list(String)
        }

  @spec new_game :: Game.t()
  defdelegate new_game(), to: Game

  @spec make_move(Game.t(), String.t()) :: {Game.t(), tally}
  def make_move(_game, _guess) do
  end
end
