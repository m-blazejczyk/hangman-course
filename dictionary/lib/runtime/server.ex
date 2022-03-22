defmodule Dictionary.Runtime.Server do
  @type t :: pid()

  @me __MODULE__

  use Agent

  alias Dictionary.Impl.WordList

  @spec start_link(list(any)) :: {:error, any} | {:ok, pid}
  def start_link(_) do
    Agent.start_link(&WordList.word_list/0, name: @me)
  end

  @spec random_word() :: String.t()
  def random_word() do
    # Code to test the supervision (crash the agent randomly in 1/3 of cases)
    if :rand.uniform() < 0.33 do
      Agent.get(@me, fn _ -> exit(:boom) end)
    end

    Agent.get(@me, &WordList.random_word/1)
  end
end
