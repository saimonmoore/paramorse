defmodule ParaMorse.LetterDecoder do

  @doc """
  Takes a character encoded in morse code and returns
  the corresponding character.

  ## Examples

    iex> ParaMorse.LetterDecoder.decode("1110111010111")
    "q"

    iex> ParaMorse.LetterDecoder.decode("10111")
    "a"

    iex> ParaMorse.LetterDecoder.decode("a")
    :error

    iex> ParaMorse.LetterDecoder.decode("2345")
    :error

    iex> ParaMorse.LetterDecoder.decode(nil)
    :error
  """
  def decode(character) do
    cond do
      Kernel.is_binary(character) and String.match?(character, ~r/[01]+/ui) ->
        String.split(character, "0")
        |> look_up_morse_code
        |> Atom.to_string
      true ->
        :error
    end
  end

  # Looks up a list of coded signals in the internal map
  # and returns the corresponding character.
  defp look_up_morse_code(list_of_coded_elements) do
    map = ParaMorse.LetterEncoder.morse_code_to_character_map
    character = Map.get(map, list_of_coded_elements)
    character
  end
end
