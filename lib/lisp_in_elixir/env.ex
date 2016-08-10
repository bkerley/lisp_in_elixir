defmodule LispInElixir.Env do
  alias LispInElixir.Env

  @default_env %{
    "+" => &Enum.sum/1,
    "-" => &Env.subtract/1,
    "*" => &Env.multiply/1,
    "/" => &Env.divide/1,
    ">" => &Env.gt/1,
    "<" => &Env.lt/1
  }

  def default_env(), do: @default_env

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
