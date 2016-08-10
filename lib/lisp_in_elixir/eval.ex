defmodule LispInElixir.Eval do
  alias LispInElixir.Env

  def eval(x, env) when is_number(x) do
    {x, env}
  end

  def eval(x, env) when is_binary(x) do
    {Env.get(x, env), env}
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

  def eval(["quote", exp], env) do
    {exp, env}
  end

  def eval([proc_name | args], initial_env) do
    {evald_args, final_env} = args
    |> Enum.map_reduce(initial_env, &eval(&1, &2))

    proc = Env.get(proc_name, final_env)

    {proc.(evald_args), final_env}
  end
end
