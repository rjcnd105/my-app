# defmodule DeopjibUtils.Ash.Type do
#   defmodule String do
#     use Ash.Type.NewType,
#       subtype_of: :string

#     use AshJsonApi.Type

#     # @base_schema %OpenApiSpex.Schema{
#     #   type: :string
#     # }

#     # @impl AshJsonApi.Type
#     # def json_schema(constraints) do
#     #   constraints |> DeopjibUtils.Debug.dbg_store() |> IO.inspect(constraints)

#     #   @base_schema
#     #   |> Map.put(:maxLength, Keyword.get(constraints, :max_length))
#     #   |> Map.put(:minLength, Keyword.get(constraints, :min_length))
#     #   |> Map.put(
#     #     :regex,
#     #     case Keyword.get(constraints, :match) do
#     #       match when is_struct(match, :re) ->
#     #         Regex.source(match)

#     #       _ ->
#     #         nil
#     #     end
#     #   )
#     # end

#     # def json_write_schema(constraints) do
#     #   @base_schema
#     #   |> Map.put(:format, "fuck")
#     # end
#   end
# end
