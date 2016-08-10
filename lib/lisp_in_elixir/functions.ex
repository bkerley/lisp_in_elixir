defmodule LispInElixir.Functions do
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

  def gt([l, r]), do: (l > r)

  def lt([l, r]), do: (l < r)
end
