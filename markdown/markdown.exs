defmodule Markdown do
  @doc """
    Parses a given string with Markdown syntax and returns the associated HTML for that string.

    ## Examples

    iex> Markdown.parse("This is a paragraph")
    "<p>This is a paragraph</p>"

    iex> Markdown.parse("#Header!\n* __Bold Item__\n* _Italic Item_")
    "<h1>Header!</h1><ul><li><em>Bold Item</em></li><li><i>Italic Item</i></li></ul>"
  """
  @spec parse(String.t()) :: String.t()
  def parse(string) do
    string
    |> String.split("\n", trim: true)
    |> Enum.map_join(&process_line(&1))
    |> replace_tags
    |> patch_list
  end

  defp process_line(text) do
    cond do
      String.starts_with?(text, "#") ->
        parse_header(text)

      String.starts_with?(text, "*") ->
        parse_list(text)

      true ->
        "<p>#{text}</p>"
    end
  end

  defp patch_list(text) do
    text |> String.replace(~r/<li>.*<\/li>/, "<ul>\\0</ul>", global: true)
  end

  defp parse_header(string) do
    [headers, text] = string |> String.split(~r<#+>, include_captures: true, trim: true)
    header_level = headers |> String.length()
    text = text |> String.trim()

    "<h#{header_level}>#{text}</h#{header_level}>"
  end

  defp parse_list(string) do
    string
    |> String.split("\n", trim: true)
    |> Enum.map(&String.replace(&1, ~r<\* >, ""))
    |> Enum.map(&"<li>#{&1}</li>")
  end

  defp replace_tags(string) do
    string
    |> String.replace(~r/\__(.*?)\__/, "<strong>\\1</strong>")
    |> String.replace(~r/\_(.*?)\_/, "<em>\\1</em>")
  end
end
