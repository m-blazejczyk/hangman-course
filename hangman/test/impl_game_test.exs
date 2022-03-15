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

  test "State doesn't change if game is won or lost" do
    for state <- [:won, :lost] do
      game = Game.new_game("hello")
      game = Map.put(game, :game_state, state)
      {new_game, _tally} = Game.make_move(game, "dummy")
      assert new_game == game
    end
  end

  test "Guessed letters are added to used letters" do
    game = Game.new_game("hello")
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state != :already_used
    {game, _tally} = Game.make_move(game, "y")
    assert game.game_state != :already_used
    {game, _tally} = Game.make_move(game, "z")
    assert game.game_state != :already_used
    assert MapSet.equal?(game.used, MapSet.new(["x", "y", "z"]))
  end

  test "Guessing a letter twice is detected" do
    game = Game.new_game("hello")
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state != :already_used
    {game, _tally} = Game.make_move(game, "y")
    assert game.game_state != :already_used
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "A guess is detected correctly as good or bad" do
    game = Game.new_game("hello")
    {_game, tally} = Game.make_move(game, "h")
    assert tally.game_state == :good_guess
    {_game, tally} = Game.make_move(game, "p")
    assert tally.game_state == :bad_guess
    {_game, tally} = Game.make_move(game, "l")
    assert tally.game_state == :good_guess
    {_game, tally} = Game.make_move(game, "i")
    assert tally.game_state == :bad_guess
  end

  test "guessing a word correctly" do
    [
      # guess, state, turns_left, letters, used
      ["a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["e", :good_guess, 6, ["_", "e", "_", "_", "_"], ["a", "e"]],
      ["s", :bad_guess, 5, ["_", "e", "_", "_", "_"], ["a", "e", "s"]],
      ["l", :good_guess, 5, ["_", "e", "l", "l", "_"], ["a", "e", "l", "s"]],
      ["o", :good_guess, 5, ["_", "e", "l", "l", "o"], ["a", "e", "l", "o", "s"]],
      ["k", :bad_guess, 4, ["_", "e", "l", "l", "o"], ["a", "e", "k", "l", "o", "s"]],
      ["h", :won, 4, ["h", "e", "l", "l", "o"], ["a", "e", "h", "k", "l", "o", "s"]]
    ]
    |> test_sequence_of_moves("hello")
  end

  test "guessing a word incorrectly" do
    [
      # guess, state, turns_left, letters, used
      ["a", :bad_guess, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["a", :already_used, 6, ["_", "_", "_", "_", "_"], ["a"]],
      ["e", :good_guess, 6, ["_", "e", "_", "_", "_"], ["a", "e"]],
      ["s", :bad_guess, 5, ["_", "e", "_", "_", "_"], ["a", "e", "s"]],
      ["l", :good_guess, 5, ["_", "e", "l", "l", "_"], ["a", "e", "l", "s"]],
      ["o", :good_guess, 5, ["_", "e", "l", "l", "o"], ["a", "e", "l", "o", "s"]],
      ["k", :bad_guess, 4, ["_", "e", "l", "l", "o"], ["a", "e", "k", "l", "o", "s"]],
      ["m", :bad_guess, 3, ["_", "e", "l", "l", "o"], ["a", "e", "k", "l", "m", "o", "s"]],
      ["n", :bad_guess, 2, ["_", "e", "l", "l", "o"], ["a", "e", "k", "l", "m", "n", "o", "s"]],
      [
        "p",
        :bad_guess,
        1,
        ["_", "e", "l", "l", "o"],
        ["a", "e", "k", "l", "m", "n", "o", "p", "s"]
      ],
      [
        "q",
        :lost,
        0,
        ["h", "e", "l", "l", "o"],
        ["a", "e", "k", "l", "m", "n", "o", "p", "q", "s"]
      ]
    ]
    |> test_sequence_of_moves("hello")
  end

  defp test_sequence_of_moves(sequence, word) do
    game = Game.new_game(word)
    Enum.reduce(sequence, game, &check_one_move/2)
  end

  defp check_one_move([guess, state, turns_left, letters, used], game) do
    {game, tally} = Game.make_move(game, guess)
    assert tally.game_state == state
    assert tally.turns_left == turns_left
    assert tally.letters == letters
    assert tally.used == used
    game
  end
end
