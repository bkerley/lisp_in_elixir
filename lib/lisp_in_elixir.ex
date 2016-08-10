defmodule LispInElixir do
  alias LispInElixir.Env
  alias LispInElixir.Eval
  alias LispInElixir.Parser
  alias LispInElixir.Tokenizer

  def eval(line) do
    line
    |> Tokenizer.tokenize
    |> Parser.parse
    |> Eval.eval(Env.default_env)
  end
end
