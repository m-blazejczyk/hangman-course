defmodule Dictionary do
  def word_list do
    File.read!("assets/words.txt")
      |> String.split(~r/\n/, trim: true)
  end

  def random_word do
    Enum.random word_list()
  end
end
