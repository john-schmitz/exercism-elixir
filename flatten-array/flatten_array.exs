defmodule FlattenArray do
  @doc """
    Accept a list and return the list flattened without nil values.

    ## Examples

      iex> FlattenArray.flatten([1, [2], 3, nil])
      [1,2,3]

      iex> FlattenArray.flatten([nil, nil])
      []

  """

  @spec flatten(list) :: list
  def flatten(list), do: flatten(list, [])
  def flatten([], result), do: result
  def flatten([head | tail], result) when head == nil, do: flatten(tail, result)
  def flatten([head | tail], result) when is_list(head), do: flatten(head, flatten(tail, result))
  def flatten([head | tail], result), do: [head | flatten(tail, result)]
end
