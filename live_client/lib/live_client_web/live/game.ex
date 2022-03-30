defmodule LiveClientWeb.Live.Game do
  use LiveClientWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~L"""
      Hello Hangman!
    """
  end
end
