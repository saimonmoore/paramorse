defmodule ParaMorse.LetterDecoder do

  @doc """
  Takes a character encoded in morse code and returns
  the corresponding character.

  ## Examples

    iex> ParaMorse.LetterDecoder.decode("1110111010111")
    "q"

    iex> ParaMorse.LetterDecoder.decode("10111")
    "a"

    iex> ParaMorse.LetterDecoder.decode("11")
    :error

    iex> ParaMorse.LetterDecoder.decode("a")
    :error

    iex> ParaMorse.LetterDecoder.decode("2345")
    :error

    iex> ParaMorse.LetterDecoder.decode(nil)
    :error
  """
  def decode(character) do
    decoded_character = decode_character(character)

    case decoded_character do
      :error -> :error
      nil -> :error
      decoded_character when Kernel.is_atom(decoded_character) ->
        Atom.to_string(decoded_character)
    end
  end

  defp decode_character(character) do
    cond do
      matches_morse_code(character) ->
        morse_to_alphanumeric(character)
      true ->
        :error
    end
  end

  # Looks up a list of coded signals in the internal map
  # and returns the corresponding character.
  defp look_up_morse_code(list_of_coded_elements) do
    map = ParaMorse.LetterEncoder.morse_code_to_character_map
    Map.get(map, list_of_coded_elements)
  end

  defp matches_morse_code(character) do
    Kernel.is_binary(character) and String.match?(character, ~r/[01]+/ui)
  end

  defp morse_to_alphanumeric(character) do
    String.split(character, "0") |> look_up_morse_code
  end
end
