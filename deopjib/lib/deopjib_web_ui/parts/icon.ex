defmodule DeopjibWebUI.Parts.Icon do
  use DeopjibWeb, :html

  # 컴파일 시간에 아이콘 목록 가져오기
  @icons_path Path.join(:code.priv_dir(:deopjib), "static/icons")
  @icons @icons_path
         |> File.ls!()
         |> Enum.filter(&String.ends_with?(&1, ".svg"))
         |> Enum.map(&String.replace(&1, ".svg", ""))
         |> Enum.map(&String.to_atom/1)

  @icon_contents @icons
                 |> Enum.map(fn icon ->
                   path = Path.join(@icons_path, "#{icon}.svg")
                   {icon, File.read!(path)}
                 end)
                 |> Map.new()

  @additional_icon_classes [
    cross_circle: "[&_path]:first:stroke-none"
  ]

  attr(:name, :atom, required: true, values: @icons)
  attr(:class, :string, default: "")
  attr(:rest, :global, default: %{})

  def render(assigns) do
    svg_content =
      process_svg_content(
        Map.get(@icon_contents, assigns.name, "<svg></svg>"),
        [@additional_icon_classes[:name], assigns.class]
        |> Enum.reject(&is_nil/1)
        |> Enum.join(" "),
        assigns.rest
      )

    assigns = assign(assigns, :svg_content, Phoenix.HTML.raw(svg_content))

    ~H"""
    {@svg_content}
    """
  end

  # SVG 처리 함수
  defp process_svg_content(svg, class, rest) do
    # SVG 태그의 열림 부분과 내용 분리
    {opening_tag, content} =
      case Regex.run(~r/(<svg[^>]*>)(.*)<\/svg>/s, svg) do
        [_, tag, inner] ->
          inner =
            Regex.replace(
              ~r/stroke="([^"]*)"|fill="([^"]*)"|stroke-width="([^"]*)"/s,
              inner,
              fn _ ->
                ""
              end
            )

          {tag, inner}

        _ ->
          {"<svg>", ""}
      end

    # 클래스 추가
    opening_tag =
      if class && class != "" do
        if String.match?(opening_tag, ~r/class="[^"]*"/) do
          Regex.replace(~r/class="([^"]*)"/, opening_tag, fn _, orig ->
            ~s(class="#{orig} #{class}")
          end)
        else
          String.replace(opening_tag, "<svg", ~s(<svg class="#{class}"))
        end
      else
        opening_tag
      end

    # 나머지 속성 추가
    opening_tag =
      Enum.reduce(rest, opening_tag, fn {key, value}, acc ->
        attr_name = key |> Atom.to_string() |> String.replace("_", "-")

        if String.match?(acc, ~r/#{attr_name}="[^"]*"/) do
          Regex.replace(~r/#{attr_name}="[^"]*"/, acc, ~s(#{attr_name}="#{value}"))
        else
          String.replace(acc, "<svg", ~s(<svg #{attr_name}="#{value}"))
        end
      end)

    # 최종 SVG 생성
    opening_tag <> content <> "</svg>"
  end

  def icons, do: @icons
end
