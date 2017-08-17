defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  def compare(a, b) do
    cond do
      equal?(a, b) -> :equal
      sublist?(a, b) -> :sublist
      superlist?(a, b) -> :superlist
      true -> :unequal
    end
  end

  def equal?(a, b), do: a === b
  def superlist?(a, b), do: sublist?(b, a)
  def sublist?(a, b) do
    a_count = Enum.count(a)
    cond do
      a_count > Enum.count(b) -> false
      Enum.take(b, a_count) === a -> true
      true ->
        [_ | tail] = b
        sublist?(a, tail)
    end
  end
end
