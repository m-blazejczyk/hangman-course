defmodule HtmlClientWeb.HangmanController do
  use HtmlClientWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
