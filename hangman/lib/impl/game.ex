defmodule Hangman.Impl.Game do
  alias Hangman.Type

  @type t :: %__MODULE__{
          turns_left: integer,
          game_state: Type.state(),
          letters: list(String.t()),
          used: MapSet.t(String.t())
        }
  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters: [],
    used: MapSet.new()
  )

  ###############################################

  @spec new_game :: t()
  def new_game do
    new_game(Dictionary.random_word())
  end

  @spec new_game(String.t()) :: t()
  def new_game(word) do
    %Hangman.Impl.Game{
      letters: word |> String.codepoints()
    }
  end

  ###############################################

  @spec make_move(t(), String.t()) :: {t(), Type.tally()}
  def make_move(game = %__MODULE__{game_state: state}, _guess)
      when state in [:won, :lost] do
    game
    |> return_with_tally()
  end

  def make_move(game = %__MODULE__{}, guess) do
    game
    |> accept_guess(guess, MapSet.member?(game.used, guess))
    |> return_with_tally()
  end

  ###############################################

  defp accept_guess(game, _guess, _already_used = true) do
    %{game | game_state: :already_used}
  end

  defp accept_guess(game, guess, _already_used = false) do
    %{game | used: MapSet.put(game.used, guess)}
    |> score_guess(Enum.member?(game.letters, guess))
  end

  defp score_guess(game, _correct_guess = true) do
    # guessed all letters?
    new_state = maybe_won(MapSet.subset?(MapSet.new(game.letters), game.used))
    %{game | game_state: new_state}
  end

  defp score_guess(game = %__MODULE__{turns_left: 1}, _bad_guess) do
    %{game | turns_left: 0, game_state: :lost}
  end

  defp score_guess(game, _bad_guess) do
    %{game | turns_left: game.turns_left - 1, game_state: :bad_guess}
  end

  defp maybe_won(_won? = true), do: :won
  defp maybe_won(_), do: :good_guess

  ###############################################

  def tally(game) do
    %{
      turns_left: game.turns_left,
      game_state: game.game_state,
      letters: reveal_guessed_letters(game),
      used: game.used |> MapSet.to_list() |> Enum.sort()
    }
  end

  defp reveal_guessed_letters(game = %__MODULE__{game_state: :lost}) do
    game.letters
  end

  defp reveal_guessed_letters(game) do
    game.letters
    |> Enum.map(fn letter -> MapSet.member?(game.used, letter) |> maybe_reveal(letter) end)
  end

  defp maybe_reveal(_guessed? = true, letter), do: letter
  defp maybe_reveal(_not_guessed?, _letter), do: "_"

  defp return_with_tally(game) do
    {game, tally(game)}
  end
end
