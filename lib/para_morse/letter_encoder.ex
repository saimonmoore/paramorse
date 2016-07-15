defmodule ParaMorse.LetterEncoder do

  @morse_signal  1
  @morse_silence  0
  @morse_dot [ @morse_signal ]
  @morse_dash [ @morse_signal, @morse_signal, @morse_signal ]
  @dot [ @morse_dot ]
  @dash [ @morse_dash ]
  @morse_part_separator [ @morse_silence ]
  @morse_letter_separator [ @morse_silence, @morse_silence, @morse_silence ]
  @morse_word_separator [ @morse_letter_separator, @morse_letter_separator, @morse_silence ]
  @more_characters %{
    a: [@dot, @dash],
    b: [@dash, @dot, @dot, @dot],
    c: [@dash, @dot, @dash, @dot],
    d: [@dash, @dot, @dot],
    e: [@dot],
    f: [@dot, @dot, @dash, @dot],
    g: [@dash, @dash, @dot],
    h: [@dot, @dot, @dot, @dot],
    i: [@dot, @dot],
    j: [@dot, @dash, @dash, @dash],
    k: [@dash, @dot, @dash],
    l: [@dot, @dash, @dot, @dot],
    m: [@dash, @dash],
    n: [@dash, @dot],
    o: [@dash, @dash, @dash],
    p: [@dot, @dash, @dash, @dot],
    q: [@dash, @dash, @dot, @dash],
    r: [@dot, @dash, @dot],
    s: [@dot, @dot, @dot],
    t: [@dash],
    u: [@dot, @dot, @dash],
    v: [@dot, @dot, @dot, @dash],
    w: [@dot, @dash, @dash],
    x: [@dash, @dot, @dot, @dash],
    y: [@dash, @dot, @dash, @dash],
    z: [@dash, @dash, @dot, @dot],
    "1": [@dot, @dash, @dash, @dash, @dash],
    "2": [@dot, @dot, @dash, @dash, @dash],
    "3": [@dot, @dot, @dot, @dash, @dash],
    "4": [@dot, @dot, @dot, @dot, @dash],
    "5": [@dot, @dot, @dot, @dot, @dot],
    "6": [@dash, @dot, @dot, @dot, @dot],
    "7": [@dash, @dash, @dot, @dot, @dot],
    "8": [@dash, @dash, @dash, @dot, @dot],
    "9": [@dash, @dash, @dash, @dash, @dot],
    "0": [@dash, @dash, @dash, @dash, @dash]
  }

  @doc """
  Accepts a single String alphanumeric character and
  converts it into a morse-encoded String

  ## Examples

    iex> ParaMorse.LetterEncoder.encode("a")
    "10111"

    iex> ParaMorse.LetterEncoder.encode("q")
    "1110111010111"

    iex> ParaMorse.LetterEncoder.encode("1")
    "10111011101110111"

    iex> ParaMorse.LetterEncoder.encode('a')
    :error

    iex> ParaMorse.LetterEncoder.encode(1)
    :error

    iex> ParaMorse.LetterEncoder.encode(nil)
    :error

    # Takes first letter of a string and encodes it. Ignores rest.
    iex> ParaMorse.LetterEncoder.encode("abc")
    "10111"

  """
  def encode(char) do
    cond do
      Kernel.is_binary(char) and String.match?(char, ~r/\w/ui) ->
        String.first(char)
        |> String.to_atom
        |> get_morse_character
        |> List.flatten
        |> Enum.join
      true ->
        :error
    end
  end

  # Looks up a character in the internal map
  # and adds appropriate silences
  defp get_morse_character(character) do
    Map.get(@more_characters, character)
    |> Enum.intersperse(@morse_silence)
  end
end
