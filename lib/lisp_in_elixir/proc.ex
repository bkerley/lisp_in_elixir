defmodule LispInElixir.Proc do
  defstruct params: [], body: nil, env: nil

  alias LispInElixir.Env
  alias LispInElixir.Eval
  alias LispInElixir.Proc

  def new(params, body, env) do
    %Proc{params: params, body: body, env: env}
  end

  def eval(proc = %Proc{params: param_names,
                        body: body,
                        env: proc_env},
           params,
           enclosing_env) do
    param_env = Enum.zip(param_names, params)
    |> Map.new

    whole_env = enclosing_env
    |> Env.merge(proc_env)
    |> Env.merge(param_env)

    {result, _inner_env} = Eval.eval(body, whole_env)

    {result, enclosing_env}
  end
end
