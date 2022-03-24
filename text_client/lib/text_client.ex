defmodule TextClient do
  @spec start() :: :ok
  def start do
    TextClient.Remote.RemoteHangman.connect()
    |> TextClient.Impl.Player.start()
  end
end
