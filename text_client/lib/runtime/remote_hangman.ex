defmodule TextClient.Remote.RemoteHangman do
  @remote_server :"hangman@DESKTOP-G43EHRA"

  def connect() do
    :rpc.call(@remote_server, Hangman, :new_game, [])
  end
end
