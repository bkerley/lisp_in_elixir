defmodule LispInElixir do
  alias LispInElixir.Env
  alias LispInElixir.Eval
  alias LispInElixir.Parser
  alias LispInElixir.Tokenizer

  def eval(line) do
    {result, _new_env} = eval(line, Env.default_env)
    result
  end

  def eval(line, env) do
    line
    |> Tokenizer.tokenize
    |> Parser.parse
    |> Eval.eval(env)
  end
end
