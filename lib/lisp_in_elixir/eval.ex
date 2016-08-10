defmodule LispInElixir.Eval do
  alias LispInElixir.Env

  def eval(x, env) when is_binary(x) or is_number(x) do
    {x, env}
  end

  def eval(["if", condition, action], env) do
    eval(["if", condition, action, nil], env)
  end

  def eval(["if", condition, action, alternative], env) do
    {truthy, modified_env} = eval(condition, env)

    cond do
      truthy -> eval(action, modified_env)
      alternative -> eval(alternative, modified_env)
      true -> {nil, modified_env}
    end
  end

  def eval(["define", var, exp], env) do
    {result, new_env} = eval(exp, env)
    {result, Env.merge(new_env, %{var => result})}
  end

  def eval([proc_name | args], env) do
    {env[proc_name].(args), env}
  end
end
