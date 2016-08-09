directories %w{config lib test}

ENV["IN_GUARD"] = "true"

guard :elixir do
  watch(%r{^test/(.*)_test\.exs$})
  watch(%r{^lib/(.+)\.ex$})           { "test" }
  watch(%r{^test/test_helper.exs$})   { "test" }
end
