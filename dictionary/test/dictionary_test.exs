defmodule DictionaryTest do
  use ExUnit.Case
  doctest Dictionary

  test "random word is returned" do
    {:ok, dict} = Dictionary.start_link()
    assert is_binary(Dictionary.random_word(dict))
  end
end
