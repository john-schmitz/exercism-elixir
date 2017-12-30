defmodule ListOps do
  # Please don't use any external modules (especially List) in your
  # implementation. The point of this exercise is to create these basic functions
  # yourself.
  #
  # Note that `++` is a function from an external module (Kernel, which is
  # automatically imported) and so shouldn't be used either.

  @spec count(list) :: non_neg_integer
  def count([]), do: 0
  def count([_ | tail]), do: 1 + count(tail)

  @spec reverse(list) :: list
  def reverse(list, reversed \\ [])
  def reverse([], reversed), do: reversed
  def reverse([head | tail], reversed), do: reverse(tail, [head | reversed])

  @spec map(list, (any -> any)) :: list
  def map([], _), do: []
  def map([head | tail], f), do: [apply(f, [head]) | map(tail, f)]

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter([], _), do: []

  def filter([head | tail], f) do
    case apply(f, [head]) do
      true -> [head | filter(tail, f)]
      false -> filter(tail, f)
    end
  end

  @type acc :: any
  @spec reduce(list, acc, (any, acc -> acc)) :: acc
  def reduce([], acc, _f), do: acc

  def reduce([head | tail], acc, f) do
    reduce(tail, apply(f, [head, acc]), f)
  end

  @spec append(list, list) :: list
  def append([], list_2), do: list_2
  def append(list_1, []), do: list_1
  def append(a, b), do: a |> reverse |> reduce(b, &[&1 | &2])

  @spec concat([[any]]) :: [any]
  def concat(ll), do: concat(reverse(ll), [])
  def concat([], result), do: result

  def concat([head | tail], result) do
    concat(tail, append(head, result))
  end
end
