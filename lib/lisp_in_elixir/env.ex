defmodule LispInElixir.Env do
  alias LispInElixir.Functions

  @default_env %{
    "+" => &Enum.sum/1,
    "-" => &Functions.subtract/1,
    "*" => &Functions.multiply/1,
    "/" => &Functions.divide/1,
    ">" => &Functions.gt/1,
    "<" => &Functions.lt/1
  }

  def default_env(), do: @default_env

  def merge(old_env, new_env) do
    Map.merge(old_env, new_env)
  end
end
