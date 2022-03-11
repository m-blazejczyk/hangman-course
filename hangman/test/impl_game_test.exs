defmodule HangmanImplGameTest do
  use ExUnit.Case
  alias Hangman.Impl.Game

  test "new game returns a struct" do
    game = Game.new_game()
    assert is_struct(game)
    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "new game returns a specific word" do
    game = Game.new_game("hello")
    assert is_struct(game)
    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert game.letters == ["h", "e", "l", "l", "o"]
  end
end
