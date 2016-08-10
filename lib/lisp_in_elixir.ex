defmodule LispInElixir do
  alias LispInElixir.Env
  alias LispInElixir.Eval
  alias LispInElixir.Parser
  alias LispInElixir.Tokenizer

  def eval(line) do
    {result, env} = line
    |> Tokenizer.tokenize
    |> Parser.parse
    |> Eval.eval(Env.default_env)

    result
  end
end
