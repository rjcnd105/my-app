defmodule DeopjibUtils.Ash.Type do
  defmodule String do
    use Ash.Type.NewType,
      subtype_of: :string

    use AshJsonApi.Type

    @base_scehma %{
      "type" => "string"
    }

    @impl AshJsonApi.Type
    def json_write_schema(constraints) do
      @base_scehma
      |> apply_min_length(Keyword.get(constraints, :min_length))
      |> apply_max_length(Keyword.get(constraints, :max_length))
      |> apply_pattern(Keyword.get(constraints, :match))
    end

    defp apply_min_length(schema, nil), do: schema

    defp apply_min_length(schema, value) when is_integer(value) and value >= 0 do
      Map.put(schema, "minLength", value)
    end

    defp apply_max_length(schema, nil), do: schema

    defp apply_max_length(schema, value) when is_integer(value) and value >= 0 do
      Map.put(schema, "maxLength", value)
    end

    defp apply_pattern(schema, nil), do: schema

    defp apply_pattern(schema, value) do
      Map.put(schema, "pattern", Regex.source(value))
    end
  end
end
