defmodule LispInElixir.Env do
  alias LispInElixir.Functions

  defmacrop f(func_name) do
    quote do
      &Functions.unquote(func_name)/1
    end
  end

  def default_env() do
    %{
      "+" => f(sum),
      "-" => f(subtract),
      "*" => f(multiply),
      "/" => f(divide),

      "not" => f(not_),
      "and" => f(and_),
      "or" => f(or_),

      "equal?" => f(eq),
      "=" => f(eq),
      ">" => f(gt),
      ">=" => f(gteq),
      "<" => f(lt),
      "<=" => f(lteq),

      "cons" => f(cons),
      "car" => f(car),
      "cdr" => f(cdr),
    }
  end

  def merge(old_env, new_env) do
    Map.merge(old_env, new_env)
  end

  def get(thing_name, env) do
    Map.get(env, thing_name, nil)
  end
end
