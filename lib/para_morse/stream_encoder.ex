defmodule ParaMorse.StreamEncoder do
  def new do
    ParaMorse.Queue.new
  end

  @doc """
  Pushes an alphanumeric character into the stream.

  Note: Character is just stored in the stream.

  ## Examples

    iex> stream = "ola ke ase" |> String.graphemes
    iex> {:ok, encoder} = ParaMorse.StreamEncoder.new
    iex> Enum.each(stream, fn(char) -> ParaMorse.StreamEncoder.receive(encoder, char) end)
    iex> ParaMorse.Queue.to_list(encoder)
    ["o", "l", "a", " ", "k", "e", " ", "a", "s", "e"]
  """
  def receive(encoder, character) do
    ParaMorse.Queue.push(encoder, character)
  end

  @doc """
  Encodes all characters currently in the stream.

  Note: Stream is empty after this is called.

  ## Examples

    iex> stream = "ola ke ase" |> String.graphemes
    iex> {:ok, encoder} = ParaMorse.StreamEncoder.new
    iex> Enum.each(stream, fn(char) -> ParaMorse.StreamEncoder.receive(encoder, char) end)
    iex> ParaMorse.StreamEncoder.encode(encoder)
    "111011101110001011101010001011100000001110101110001000000010111000101010001"
    iex> ParaMorse.Queue.to_list(encoder)
    []
  """
  def encode(encoder) do
    ParaMorse.Queue.pop_all(encoder)
    |> Enum.join("")
    |> ParaMorse.Encoder.encode
  end
end

