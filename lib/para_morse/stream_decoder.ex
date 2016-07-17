defmodule ParaMorse.StreamDecoder do
  def new do
    ParaMorse.Queue.new
  end

  @doc """
  Pushes a morse-encoded character (0 or 1) into the stream.

  Note: Character is just stored in the stream.

  ## Examples

    iex> stream = "10101" |> String.graphemes
    iex> {:ok, decoder} = ParaMorse.StreamDecoder.new
    iex> Enum.each(stream, fn(char) -> ParaMorse.StreamDecoder.receive(decoder, char) end)
    iex> ParaMorse.Queue.to_list(decoder)
    ["1", "0", "1", "0", "1"]
  """
  def receive(decoder, character) do
    ParaMorse.Queue.push(decoder, character)
  end

  @doc """
  Decodes existing morse-encoded characters (0/1) in the stream into alphanumeric characters.

  Note: If there are trailing silences in the stream will leave
        those in the stream so they can be completed.

  ## Examples

    iex> partial_stream = "10111011100010101010001011100011100000001011101010001010001110111010001010101000111000000011100010101010001011101000111011101110001010111000111011101000101010100000001110101110111000111011101110001110100011101010001000101110100000001011101110001010001110100011101010001110111011100010111011100000001110101010001011101000100010111000111010111000" |> String.graphemes
    iex> rest_of_stream = "10101" |> String.graphemes
    iex> {:ok, decoder} = ParaMorse.StreamDecoder.new
    iex> Enum.each(partial_stream, fn(char) -> ParaMorse.StreamDecoder.receive(decoder, char) end)
    iex> ParaMorse.StreamDecoder.decode(decoder)
    "what light through yonder window break"
    iex> Enum.each(rest_of_stream, fn(char) -> ParaMorse.StreamDecoder.receive(decoder, char) end)
    iex> ParaMorse.StreamDecoder.decode(decoder)
    "s"
  """
  def decode(decoder) do
    characters = ParaMorse.Queue.to_list(decoder) |> Enum.join("")
    number_to_pop = position_trailing_silences_start(characters)
    ParaMorse.Queue.pop_multiple(decoder, number_to_pop)
    |> Enum.join("")
    |> ParaMorse.Encoder.decode
  end

  defp number_ignored_trailing_silences(characters) do
    matches = Regex.scan(~r/(0)+$/, characters)
              |> List.flatten
              |> List.first
    cond do
      Kernel.is_nil(matches) -> 0
      String.match?(matches, ~r/0+/) -> String.length(matches)
    end
  end

  defp position_trailing_silences_start(characters) do
    String.length(characters) - number_ignored_trailing_silences(characters)
  end
end
