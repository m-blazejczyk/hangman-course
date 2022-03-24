defmodule TextClient.Impl.Player do
  @type game :: Hangman.game()
  @type tally :: Hangman.Type.tally()

  @spec start(game()) :: :ok
  def start(game) do
    tally = Hangman.tally(game)
    interact(game, tally)
  end

  # @type state :: :initializing | :won | :lost | :good_guess | :bad_guess | :already_used
  @spec interact(game(), tally()) :: :ok
  defp interact(_game, tally = %{game_state: :won}) do
    IO.puts("Congratulations ‒ you won!")
    IO.puts("The word was: #{tally.letters |> Enum.join()}")
  end

  defp interact(_game, tally = %{game_state: :lost}) do
    IO.puts("Sorry, you lost  :(")
    IO.puts("The word was: #{tally.letters |> Enum.join()}")
  end

  defp interact(game, tally) do
    IO.puts("")
    IO.puts(feedback_for(tally))
    IO.puts(explain_tally(tally))

    tally = Hangman.make_move(game, enter_guess())
    interact(game, tally)
  end

  @spec feedback_for(tally()) :: String.t()
  defp feedback_for(tally = %{game_state: :initializing}) do
    "Welcome! I’m thinking of a #{length(tally.letters)}-letter word…"
  end

  defp feedback_for(%{game_state: :already_used}), do: "You already picked this letter  :)"
  defp feedback_for(%{game_state: :good_guess}), do: "Good guess!!!"
  defp feedback_for(%{game_state: :bad_guess}), do: "Sorry, this letter is not in the word…"

  defp explain_tally(tally) do
    [
      "#{tally.turns_left} guesses left;",
      "  word so far: #{tally.letters |> Enum.join(" ")};",
      "  used so far: #{tally.used |> Enum.join(",")}"
    ]
  end

  defp enter_guess() do
    IO.gets("Next guess:")
    |> String.trim()
    |> String.downcase()
    |> String.first()
  end
end
