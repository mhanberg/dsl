defmodule Temple.Parser.Components do
  @moduledoc false
  @behaviour Temple.Parser

  alias Temple.Buffer

  def applicable?({:c, _, _}) do
    true
  end

  def applicable?(_), do: false

  def run({:c, meta, [component_module, [do: _] = block]}) do
    run({:c, meta, [component_module, [], block]})
  end

  def run({:c, _meta, [component_module, args, [do: block]]}) do
    Temple.Ast.new(
      meta: %{type: :component},
      content: Macro.expand_once(component_module, __ENV__),
      attrs: args,
      children: block
    )
  end

  def run({:c, _meta, [component_module | args]}, buffer) do
    import Temple.Parser.Private

    {assigns, children} =
      case args do
        [assigns, [do: block]] ->
          {assigns, block}

        [[do: block]] ->
          {[], block}

        [assigns] ->
          {assigns, nil}

        _ ->
          {[], nil}
      end

    if children do
      Buffer.put(
        buffer,
        "<%= Phoenix.View.render_layout #{Macro.to_string(component_module)}, :self, #{
          Macro.to_string(assigns)
        } do %>"
      )

      traverse(buffer, children)

      Buffer.put(buffer, "<% end %>")
    else
      Buffer.put(
        buffer,
        "<%= Phoenix.View.render #{Macro.to_string(component_module)}, :self, #{
          Macro.to_string(assigns)
        } %>"
      )
    end

    :ok
  end
end
