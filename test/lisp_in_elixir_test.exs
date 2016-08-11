defmodule LispInElixirTest do
  use ExUnit.Case
  doctest LispInElixir

  import LispInElixir, only: [eval: 1, eval: 2]

  @delta 0.001

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

  test "unusual arithmetic" do
    assert eval("(+ 1 (quote ()))") == 1
  end

  test "conditions" do
    assert eval("(if (> 2 1) 3 4)") == 3
    assert eval("(if (> 1 2) 3 4)") == 4
  end

  test "booleans" do
    assert eval("(if (not (quote ())) 3 4)") == 3
    assert eval("(if (not 1) 3 4)") == 4
    assert eval("(if (and (quote ()) 1) 3 4)") == 4
    assert eval("(if (or (quote ()) 1) 3 4)") == 3
  end

  test "condition truthiness" do
    assert eval("(if (quote ()) 3 4)") == 4
  end

  test "define" do
    initial_env = LispInElixir.Env.default_env

    assert {11, new_env} = eval("(define x (+ 5 6))", initial_env)
    assert {11, ^new_env} = eval("(+ x 0)", new_env)
  end

  test "quote" do
    assert ["+", 1, 2] = eval("(quote (+ 1 2))")
    assert [1, 2, 3] = eval("(quote (1 2 3))")
  end

  test "begin" do
    assert 3 == eval("(begin (+ 1 1) (+ 1 2))")
  end

  test "lambda" do
    assert eval("((lambda (x y) (begin (+ x y))) 1 2)") == 3
  end

  test "car and cdr" do
    assert 3 == eval("(car (quote (3 2 1)))")
    assert [2, 1] == eval("(cdr (quote (3 2 1)))")
  end

  test "circle area" do
    initial_env = LispInElixir.Env.default_env

    assert {pi, with_pi_env} =
      eval("(define pi 3.14159)", initial_env)

    assert_in_delta pi, 3.14150, @delta

    assert {_, with_circle_env} =
      eval("(define circle-area (lambda (r) (* pi (* r r))))", with_pi_env)

    assert {new_pi, ^with_circle_env} =
      eval("(circle-area 1)", with_circle_env)

    assert_in_delta new_pi, 3.14159, @delta

    assert {pi_nine, ^with_circle_env} =
      eval("(circle-area 3)", with_circle_env)

    assert_in_delta pi_nine, 28.27433, @delta
  end

  test "factorial" do
    assert 3628800 == eval("""
    (begin
      (define fact (lambda (n) (if (<= n 1) 1 (* n (fact (- n 1))))))
      (fact 10))
    """)
  end

  test "count" do
    assert 4 == eval("""
    (begin
      (define count
        (lambda (item L)
          (if L
            (+ (equal? item (car L))
            (count item (cdr L)))
            0)))
      (count (quote the) (quote (the more the merrier the bigger the better))))
    """)
  end
end
