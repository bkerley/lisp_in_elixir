defmodule LispInElixir.Eval do
  def eval(x, _env) when is_binary(x) or is_number(x) do
    x
  end

  def eval([proc_name | args], env) do
    env[proc_name].(args)
  end
end
