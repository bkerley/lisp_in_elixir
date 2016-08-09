defmodule LispInElixirTest do
  use ExUnit.Case
  doctest LispInElixir

  test "arithmetic" do
    assert LispInElixir.eval("(+ 1 2)") == 3
  end
end
