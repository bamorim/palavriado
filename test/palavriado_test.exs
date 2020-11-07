defmodule PalavriadoTest do
  use ExUnit.Case
  doctest Palavriado

  test "greets the world" do
    assert Palavriado.hello() == :world
  end
end
