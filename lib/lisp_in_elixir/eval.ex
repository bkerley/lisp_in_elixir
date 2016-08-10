defmodule LispInElixir.Eval do
  def eval(x, _env) when is_binary(x) or is_number(x) do
    x
  end

  def eval(["if", condition, action], env) do
    eval(["if", condition, action, nil], env)
  end

  def eval(["if", condition, action, exception], env) do
    cond do
      eval(condition, env) -> eval(action, env)
      exception -> eval(exception, env)
      true -> nil
    end
  end

  def eval([proc_name | args], env) do
    env[proc_name].(args)
  end
end
