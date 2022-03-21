defmodule DictionaryTest do
  use ExUnit.Case
  doctest Dictionary

  test "random word is returned" do
    assert is_binary(Dictionary.random_word())
  end
end
