defmodule School do
  use GenServer

  @moduledoc """
  Simulate students in a school.

  Each student is in a grade.
  """

  @doc """
  Add a student to a particular grade in school.
  """
  @spec add(map, String.t(), integer) :: map
  def add(_db, name, grade) do
    start_server_if_needed()
    GenServer.call(:local_school, {:add, name, grade})
  end

  @doc """
  Return the names of the students in a particular grade.
  """
  @spec grade(map, integer) :: [String.t()]
  def grade(_db, grade) do
    start_server_if_needed()
    GenServer.call(:local_school, {:grade, grade})
  end

  @doc """
  Sorts the school by grade and name.
  """
  @spec sort(map) :: [{integer, [String.t()]}]
  def sort(_db) do
    start_server_if_needed()
    GenServer.call(:local_school, {:sort_by_grade})
  end

  defp start_server_if_needed do
    if Process.whereis(:local_school) == nil do
      GenServer.start_link(__MODULE__, :ok, name: :local_school)
    end
  end

  ### GenServer Callbacks
  def init(:ok), do: {:ok, %{}}

  def handle_call({:add, name, grade}, _from, students) do
    new_map = Map.update(students, grade, [name], &Enum.sort([name | &1]))
    {:reply, new_map, new_map}
  end

  def handle_call({:grade, grade}, _from, students) do
    {:reply, Map.get(students, grade, []), students}
  end

  def handle_call({:sort_by_grade}, _from, students) do
    sorted_students =
      students
      |> Map.to_list()
      |> Enum.sort(fn {grade1, _}, {grade2, _} -> grade1 < grade2 end)

    {:reply, sorted_students, students}
  end
end
