defmodule Temple.Parser.Slot do
  @moduledoc false
  @behaviour Temple.Parser

  defstruct name: nil, args: []

  @impl true
  def applicable?({:slot, _, _}) do
    true
  end

  def applicable?(_), do: false

  @impl true
  def run({:slot, _, [slot_name | rest]}) do
    args =
      case rest do
        [args] ->
          args

        _ ->
          []
      end

    Temple.Ast.new(__MODULE__, name: slot_name, args: args)
  end

  defimpl Temple.Generator do
    def to_eex(%{name: name, args: args}) do
      render_block_function = Temple.Config.mode().render_block_function

      [
        "<%= #{render_block_function}(@inner_block, {:",
        to_string(name),
        ", ",
        Macro.to_string(quote(do: Enum.into(unquote(args), %{}))),
        "}) %>"
      ]
    end
  end
end
