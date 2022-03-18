defmodule DictionaryTest do
  use ExUnit.Case
  doctest Dictionary

  test "random word is returned" do
    words = Dictionary.start()
    assert is_binary(Dictionary.random_word(words))
  end
end
