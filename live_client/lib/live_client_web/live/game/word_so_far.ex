defmodule LiveClientWeb.Live.Game.WordSoFar do
  use LiveClientWeb, :live_component

  @state_names %{
    initializing: "Type or click your first guess",
    good_guess: "Good guess!",
    bad_guess: "Sorry, that's a bad guess  :(",
    won: "You won!",
    lost: "Sorry, you lost…  :(",
    already_used: "You already used that letter"
  }

  defp state_name(state), do: @state_names[state] || "Unknown game state"

  defp letter_class(ch), do: if(ch != "_", do: "one-letter correct", else: "one-letter")

  def render(assigns) do
    ~H"""
    <div class="word-so-far">
      <div class="game-state">
        <%= state_name(@tally.game_state) %>
      </div>
      <div class="letters">
        <%= for ch <- @tally.letters do %>
          <% cls = letter_class(ch) %>
          <div class={cls}>
            <%= ch %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
