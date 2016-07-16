defmodule ParaMorse.Encoder do

  @doc """
  Takes a word and returns
  the corresponding characters encoded in morse code.

  ## Examples

    iex> ParaMorse.Encoder.encode("Word")
    "1011101110001110111011100010111010001110101"

  """
  def encode(word) do
    cond do
      Kernel.is_binary(word) and String.match?(word, ~r/\w+/ui) ->
        characters = String.downcase(word) |> String.codepoints

        Enum.map(characters, fn(char) -> encode_character(char) end)
        |> Enum.join(letter_delimiter)
      true ->
        :error
    end
  end

  @doc """
  Takes a word and returns
  the corresponding characters encoded in morse code.

  ## Examples

    iex> ParaMorse.Encoder.decode("1011101110001110111011100010111010001110101")
    "word"

  """
  def decode(string) do
    cond do
      Kernel.is_binary(string) and String.match?(string, ~r/[01]+/ui) ->
        characters = String.split(string, letter_delimiter)
        Enum.map(characters, fn(char) -> decode_character(char) end)
        |> Enum.join
      true ->
        :error
    end
  end

  # Delegates to LetterEncoder
  defp encode_character(character) do
    ParaMorse.LetterEncoder.encode(character)
  end

  # Delegates to LetterDecoder
  defp decode_character(character) do
    ParaMorse.LetterDecoder.decode(character)
  end

  # Returns the letter delimiter
  defp letter_delimiter do
    ParaMorse.LetterEncoder.letter_delimiter
  end
end
