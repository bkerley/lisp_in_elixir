defmodule LispInElixir.Functions do
  alias LispInElixir.Eval

  @doc ~S"""
  iex> sum([1, 2, 3])
  6

  iex> sum([1.2, 4.6, 9.99])
  15.79
  """
  def sum(args) do
    args
    |> Enum.reduce(0, fn
      (x, y) when is_number(x) -> x + y;
      (true, y) -> 1 + y;
      (_x, y) -> y
    end)
  end

  def subtract(args) do
    args
    |> Enum.reverse
    |> Enum.reduce(&Kernel.-/2)
  end

  def multiply(args) do
    args
    |> Enum.reduce(&Kernel.*/2)
  end

  def divide(args) do
    args
    |> Enum.reverse
    |> Enum.reduce(&Kernel.//2)
  end

  def not_([[]]), do: true
  def not_([false]), do: true
  def not_([nil]), do: true
  def not_([_other]), do: false

  @doc ~S"""
  iex> and_([1, "bees", 5.5])
  true

  iex> and_([0, 1, 2])
  true

  iex> and_([[], 5])
  false

  iex> and_([false, 5])
  false

  iex> and_([1, 2, 3, nil])
  false
  """
  def and_(args) do
    args
    |> Enum.all?(&Eval.truthy?(&1))
  end

  def or_(args) do
    args
    |> Enum.any?(&Eval.truthy?(&1))
  end

  def eq([l, r]), do: (l == r)
  def gt([l, r]), do: (l > r)
  def gteq([l, r]), do: (l >= r)
  def lt([l, r]), do: (l < r)
  def lteq([l, r]), do: (l <= r)

  def car([[]]), do: nil
  def car([[first | _rest]]), do: first

  def cdr([[]]), do: nil
  def cdr([[_first | rest]]), do: rest
end
