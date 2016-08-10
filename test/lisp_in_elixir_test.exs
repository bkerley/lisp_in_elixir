defmodule LispInElixirTest do
  use ExUnit.Case
  doctest LispInElixir

  import LispInElixir, only: [eval: 1]

  @delta 0.000000000001

  test "integer arithmetic" do
    assert LispInElixir.eval("(+ 1 2)") == 3
    assert LispInElixir.eval("(- 2 1)") == 1
    assert LispInElixir.eval("(* 1 2 3 4)") == 24
    assert LispInElixir.eval("(/ 6 3)") == 2
  end

  test "float arithmetic" do
    assert_in_delta LispInElixir.eval("(+ 1.5 2.0)"), 3.5, @delta
    assert_in_delta LispInElixir.eval("(- 1.2 2.2)"), -1.0, @delta
    assert_in_delta LispInElixir.eval("(* 5.0 2.5)"), 12.5, @delta
    assert_in_delta LispInElixir.eval("(/ 5.0 2.5)"), 2.0, @delta
  end

  test "conditions" do
    assert eval("(if (> 2 1) 3 4)") == 3
    assert eval("(if (> 1 2) 3 4)") == 4
  end
end
