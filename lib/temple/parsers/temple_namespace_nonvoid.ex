defmodule Temple.Parser.TempleNamespaceNonvoid do
  @moduledoc false
  @behaviour Temple.Parser

  defstruct content: nil, attrs: [], children: []

  alias Temple.Parser
  alias Temple.Buffer

  @impl Parser
  def applicable?({{:., _, [{:__aliases__, _, [:Temple]}, name]}, _meta, _args}) do
    name in Parser.nonvoid_elements_aliases()
  end

  def applicable?(_), do: false

  def run({name, meta, args}) do
    {:., _, [{:__aliases__, _, [:Temple]}, name]} = name
    Temple.Parser.NonvoidElementsAliases.run({name, meta, args})
  end

  @impl Parser
  def run({name, _, args}, buffer) do
    import Temple.Parser.Private
    {:., _, [{:__aliases__, _, [:Temple]}, name]} = name

    {do_and_else, args} =
      args
      |> split_args()

    {do_and_else, args} =
      case args do
        [args] when is_list(args) ->
          {do_value, args} = Keyword.pop(args, :do)

          do_and_else = Keyword.put_new(do_and_else, :do, do_value)

          {do_and_else, args}

        _ ->
          {do_and_else, args}
      end

    name = Parser.nonvoid_elements_lookup()[name]

    {compact?, args} = pop_compact?(args)

    Buffer.put(buffer, "<#{name}#{compile_attrs(args)}>")
    unless compact?, do: Buffer.put(buffer, "\n")
    traverse(buffer, do_and_else[:do])
    if compact?, do: Buffer.remove_new_line(buffer)
    Buffer.put(buffer, "</#{name}>")
    Buffer.put(buffer, "\n")

    :ok
  end
end
