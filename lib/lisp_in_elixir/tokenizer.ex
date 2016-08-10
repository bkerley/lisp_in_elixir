defmodule LispInElixir.Tokenizer do

  @doc ~S"""
  iex> LispInElixir.Tokenizer.tokenize("(+ 1 2)")
  ["(", "+", "1", "2", ")"]

  iex> LispInElixir.Tokenizer.tokenize("(+ 1 2(+ 2 3 45))")
  ["(", "+", "1", "2", "(", "+", "2", "3", "45", ")", ")"]

  # test from http://www.norvig.com/lispy.html
  iex> LispInElixir.Tokenizer.tokenize("(begin (define r 10) (* pi (* r r)))")
  ~W{( begin ( define r 10 ) ( * pi ( * r r ) ) )}
  """
  def tokenize(chars) do
    chars
    |> String.replace("(", " ( ")
    |> String.replace(")", " ) ")
    |> String.split
  end
end
