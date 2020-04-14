defmodule Temple.LiveViewEngine do
  @behaviour Phoenix.Template.Engine

  def compile(path, _name) do
    require Temple

    template = path |> File.read!() |> Code.string_to_quoted!(file: path)

    ast =
      quote do
        unquote(template)
      end

    Temple.temple(ast)
    |> EEx.compile_string(engine: Phoenix.LiveView.Engine, file: path, line: 1)
  end
end
