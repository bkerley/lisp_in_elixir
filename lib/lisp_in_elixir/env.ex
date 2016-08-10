defmodule LispInElixir.Env do
  @default_env %{
    "+" => &Enum.sum(&1)
  }

  def default_env(), do: @default_env
end
