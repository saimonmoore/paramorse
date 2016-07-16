defmodule ParaMorse.Encoder do

  @doc """
  Takes a word and returns
  the corresponding characters encoded in morse code.

  ## Examples

    iex> ParaMorse.Encoder.encode("Word")
    "1011101110001110111011100010111010001110101"

    iex> ParaMorse.Encoder.encode("What light through yonder window breaks")
    "1011101110001010101000101110001110000000101110101000101000111011101000101010100011100000001110001010101000101110100011101110111000101011100011101110100010101010000000111010111011100011101110111000111010001110101000100010111010000000101110111000101000111010001110101000111011101110001011101110000000111010101000101110100010001011100011101011100010101"

  """
  def encode(string) do
    cond do
      Kernel.is_binary(string) and String.match?(string, ~r/\w+/ui) ->
        words = String.split(string, ~r/\s+/)

        Enum.map(words, fn(word) -> encode_word(word) end)
        |> Enum.join(word_delimiter)
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

    iex> ParaMorse.Encoder.decode("1011101110001010101000101110001110000000101110101000101000111011101000101010100011100000001110001010101000101110100011101110111000101011100011101110100010101010000000111010111011100011101110111000111010001110101000100010111010000000101110111000101000111010001110101000111011101110001011101110000000111010101000101110100010001011100011101011100010101")
    "what light through yonder window breaks"


  """
  def decode(string) do
    cond do
      Kernel.is_binary(string) and String.match?(string, ~r/[01]+/ui) ->
        words = String.split(string, word_delimiter)
        Enum.map(words, fn(word) -> decode_word(word) end)
        |> Enum.join(" ")
      true ->
        :error
    end
  end

  defp encode_word(word) do
    characters = String.downcase(word) |> String.codepoints
    Enum.map(characters, fn(char) -> encode_character(char) end)
    |> Enum.join(letter_delimiter)
  end

  defp decode_word(word) do
    characters = String.split(word, letter_delimiter)
    Enum.map(characters, fn(char) -> decode_character(char) end)
    |> Enum.join
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

  defp word_delimiter do
    ParaMorse.LetterEncoder.word_delimiter
  end
end
