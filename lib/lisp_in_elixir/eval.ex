defmodule LispInElixir.Eval do
  alias LispInElixir.Env
  alias LispInElixir.Proc

  def eval(x, env) when is_number(x) do
    {x, env}
  end

  def eval(x, env) when is_binary(x) do
    {Env.get(x, env), env}
  end

  def eval(nil, env) do
    {[], env}
  end

  def eval(["if", condition, action], env) do
    eval(["if", condition, action, nil], env)
  end

  def eval(["if", condition, action, alternative], env) do
    {condition_result, modified_env} = eval(condition, env)

    truthiness = truthy?(condition_result)

    cond do
      truthiness -> eval(action, modified_env)
      alternative -> eval(alternative, modified_env)
      true -> {nil, modified_env}
    end
  end

  def eval(["lambda", params, body], env) do
    {Proc.new(params, body, env), env}
  end

  def eval([["lambda", params, body] | args], env) do
    {lda, post_lambda_env} = eval(["lambda", params, body], env)
    {evald_args, post_args_env} = eval_arg_list(args, post_lambda_env)
    inner_eval(nil, lda, evald_args, post_args_env)
  end

  def eval([proc = %Proc{} | args], env) do
    {arg_list, post_arg_env} = eval_arg_list(args, env)

    Proc.eval(proc, arg_list, post_arg_env)
  end

  def eval(["define", var, exp], env) do
    {result, new_env} = eval(exp, env)
    {result, Env.merge(new_env, %{var => result})}
  end

  def eval(["quote", exp], env) do
    {exp, env}
  end

  def eval(["begin" | exprs], env) do
    Enum.reduce(exprs, {nil, env}, fn(expr, {_prev_result, inner_env}) ->
      eval(expr, inner_env)
    end)
  end

  def eval([proc_name | args], initial_env) do
    {evald_args, final_env} = eval_arg_list(args, initial_env)

    proc = Env.get(proc_name, final_env)

    inner_eval(proc_name, proc, evald_args, final_env)
  end

  defp inner_eval(proc_name, nil, _, _) do
    raise "Couldn't find proc #{proc_name}"
  end

  defp inner_eval(_proc_name, proc = %Proc{}, evald_args, final_env) do
    Proc.eval(proc, evald_args, final_env)
  end

  defp inner_eval(_proc_name, func, evald_args, final_env)
  when is_function(func) do
    {func.(evald_args), final_env}
  end

  @doc ~S"""
  iex> truthy? []
  false

  iex> truthy? nil
  false

  iex> truthy? 5
  true

  iex> truthy? 0
  true
  """
  def truthy?([]), do: false
  def truthy?(nil), do: false
  def truthy?(false), do: false
  def truthy?(_other), do: true

  defp eval_arg_list(args, initial_env) do
    Enum.map_reduce(args, initial_env, &eval(&1, &2))
  end
end
