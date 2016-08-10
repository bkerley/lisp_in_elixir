defmodule LispInElixir.Parser do

  alias LispInElixir.Tokenizer

  @doc ~S"""
  iex> LispInElixir.Parser.parse("(begin (define r 10) (* pi (* r r)))")
  ["begin", ["define", "r", 10], ["*", "pi", ["*", "r", "r"]]]

  iex> LispInElixir.Parser.parse("()")
  []

  iex> LispInElixir.Parser.parse("(begin)")
  ["begin"]

  iex> LispInElixir.Parser.parse(~w{( )}, [])
  [[]]

  iex> LispInElixir.Parser.parse(~w{( ( ) )}, [])
  [[[]]]

  iex> LispInElixir.Parser.parse(~w{( begin )}, [])
  [["begin"]]
  """

  def parse(line) when is_binary(line) do
    line |> Tokenizer.tokenize |> parse
  end

  def parse(line) when is_list(line) do
    line |> parse([]) |> unwrap
  end

  def parse([], acc) do
    Enum.reverse(acc)
  end

  def parse(["(" | rest], acc) do
    {inner, remain} = parse(rest, [])

    parse(remain, [inner | acc])
  end

  def parse([")" | rest], acc) do
    {Enum.reverse(acc),
     rest}
  end

  def parse([tok | rest], acc) do
    parse(rest, [atomize(tok) | acc])
  end

  def unwrap([val]) do
    val
  end

  @doc ~S"""
  iex> LispInElixir.Parser.atomize("5")
  5

  iex> LispInElixir.Parser.atomize("5.0")
  5.0

  iex> LispInElixir.Parser.atomize("kevin")
  "kevin"
  """

  def atomize(token) do
    cond do
      match?({_int, ""}, Integer.parse(token)) ->
        {int, ""} = Integer.parse(token)
        int
      match?({_flo, ""}, Float.parse(token)) ->
        {flo, ""} = Float.parse(token)
        flo
      token -> token
    end
  end

end
