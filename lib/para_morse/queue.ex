defmodule ParaMorse.Queue do

  @doc """
  Creates a new ParaMorse.Queue

  ## Examples

    iex> {:ok, queue} = ParaMorse.Queue.new
    iex> Kernel.is_pid(queue)
    true

  """
  def new do
    Agent.start_link(fn -> [] end)
  end

  @doc """
  Pushes an element onto a ParaMorse.Queue

  ## Examples

    iex> {:ok, queue} = ParaMorse.Queue.new
    iex> ParaMorse.Queue.push(queue, 1)
    :ok

  """
  def push(queue, item) do
    Agent.update(queue, &(&1 ++ [item]))
  end

  @doc """
  Converts the ParaMorse.Queue into a list

  ## Examples

    iex> {:ok, queue} = ParaMorse.Queue.new
    iex> ParaMorse.Queue.push(queue, 1)
    iex> ParaMorse.Queue.push(queue, 1)
    iex> ParaMorse.Queue.push(queue, 0)
    iex> ParaMorse.Queue.to_list(queue)
    [1,1,0]

  """
  def to_list(queue) do
    Agent.get(queue, &(&1))
  end

  @doc """
  Counts the number of elements in a ParaMorse.Queue

  ## Examples

    iex> {:ok, queue} = ParaMorse.Queue.new
    iex> ParaMorse.Queue.push(queue, 1)
    iex> ParaMorse.Queue.push(queue, 0)
    iex> ParaMorse.Queue.push(queue, 1)
    iex> ParaMorse.Queue.count(queue)
    3

  """
  def count(queue) do
    Agent.get(queue, &(&1))
    |> Enum.count
  end

  @doc """
  Returns the last element of a ParaMorse.Queue

  ## Examples

    iex> {:ok, queue} = ParaMorse.Queue.new
    iex> ParaMorse.Queue.push(queue, 1)
    iex> ParaMorse.Queue.push(queue, 0)
    iex> ParaMorse.Queue.push(queue, 0)
    iex> ParaMorse.Queue.tail(queue)
    0

  """
  def tail(queue) do
    Agent.get(queue, &(&1))
    |> Enum.reverse
    |> Enum.at(0)
  end

  @doc """
  Returns the first element of a ParaMorse.Queue

  ## Examples

    iex> {:ok, queue} = ParaMorse.Queue.new
    iex> ParaMorse.Queue.push(queue, 1)
    iex> ParaMorse.Queue.push(queue, 0)
    iex> ParaMorse.Queue.push(queue, 0)
    iex> ParaMorse.Queue.peek(queue)
    1

  """
  def peek(queue) do
    Agent.get(queue, &(&1))
    |> Enum.at(0)
  end

  @doc """
  Returns the first n elements of a ParaMorse.Queue

  ## Examples

    iex> {:ok, queue} = ParaMorse.Queue.new
    iex> ParaMorse.Queue.push(queue, 1)
    iex> ParaMorse.Queue.push(queue, 0)
    iex> ParaMorse.Queue.push(queue, 1)
    iex> ParaMorse.Queue.push(queue, 1)
    iex> ParaMorse.Queue.peek_multiple(queue, 3)
    [1,0,1]

  """
  def peek_multiple(queue, n) do
    Agent.get(queue, &(&1))
    |> Enum.take(n)
  end

  @doc """
  Removes and returns the first element of a ParaMorse.Queue

  ## Examples

    iex> {:ok, queue} = ParaMorse.Queue.new
    iex> ParaMorse.Queue.push(queue, 1)
    iex> ParaMorse.Queue.push(queue, 0)
    iex> ParaMorse.Queue.push(queue, 1)
    iex> ParaMorse.Queue.push(queue, 1)
    iex> ParaMorse.Queue.pop(queue)
    1

  """
  def pop(queue) do
    [h | rest] = Agent.get(queue, &(&1))
    Agent.update(queue, fn(_) -> rest end)
    h
  end

  @doc """
  Removes and returns the first n elements of a ParaMorse.Queue

  ## Examples

    iex> {:ok, queue} = ParaMorse.Queue.new
    iex> ParaMorse.Queue.push(queue, 1)
    iex> ParaMorse.Queue.push(queue, 0)
    iex> ParaMorse.Queue.push(queue, 1)
    iex> ParaMorse.Queue.push(queue, 0)
    iex> ParaMorse.Queue.pop_multiple(queue, 3)
    [1,0,1]
    iex> ParaMorse.Queue.to_list(queue)
    [0]

  """
  def pop_multiple(queue, n) do
    list = Agent.get(queue, &(&1))
    split_list = Enum.split(list, n)
    Agent.update(queue, fn(_) -> elem(split_list, 1) end)
    elem(split_list, 0)
  end

  @doc """
  Removes all elements of a ParaMorse.Queue

  ## Examples

    iex> {:ok, queue} = ParaMorse.Queue.new
    iex> ParaMorse.Queue.push(queue, 1)
    iex> ParaMorse.Queue.push(queue, 0)
    iex> ParaMorse.Queue.push(queue, 1)
    iex> ParaMorse.Queue.push(queue, 1)
    iex> ParaMorse.Queue.clear(queue)
    :ok
    iex> ParaMorse.Queue.count(queue)
    0

  """
  def clear(queue) do
    Agent.update(queue, fn(_) -> [] end)
    :ok
  end
end
