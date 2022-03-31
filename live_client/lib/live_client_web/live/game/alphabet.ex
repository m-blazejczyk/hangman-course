defmodule LiveClientWeb.Live.Game.Alphabet do
  use LiveClientWeb, :live_component

  def mount(socket) do
    letters = ?a..?z |> Enum.map(&<<&1::utf8>>)
    {:ok, assign(socket, :letters, letters)}
  end

  def render(assigns) do
    ~H"""
    <div class="alphabet">
      <%= for ch <- assigns.letters do %>
        <div
          phx-click="make_move"
          phx-value-key={ch}
          class={"one-letter #{classOf(ch, @tally)}"}
        >
          <%= ch %>
        </div>
      <% end %>
    </div>
    """
  end

  defp classOf(letter, tally) do
    cond do
      Enum.member?(tally.letters, letter) -> "correct"
      Enum.member?(tally.used, letter) -> "wrong"
      true -> ""
    end
  end
end
