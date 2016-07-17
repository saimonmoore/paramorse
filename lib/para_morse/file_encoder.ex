defmodule ParaMorse.FileEncoder do
  @doc ~S"""
  Reads an `input` file with alphanumeric characters and writes an `output` file
  encoded in morse.

  ## Examples

   iex> String.graphemes("line 1\n and line 2\n and line 3") |>
   iex> Stream.into(File.stream!("sample.txt")) |>
   iex> Stream.run
   :ok
   iex> ParaMorse.FileEncoder.encode("sample.txt", "encoded.txt")
   iex> File.stream!("encoded.txt")
   iex> |> Enum.to_list
   iex> |> Enum.join("")
   "1011101010001010001110100010000000101110111011101110000000000000010111000111010001110101000000010111010100010100011101000100000001010111011101110000000000000010111000111010001110101000000010111010100010100011101000100000001010101110111"
   iex> File.rm("sample.txt")
   iex> File.rm("encoded.txt")
   :ok

  """
  def encode(input, output) do
    file_stream(input)
    |> Stream.map(&ParaMorse.Encoder.encode(&1))
    |> Stream.into(File.stream!(output))
    |> Stream.run
  end

  defp file_stream(input) do
    Stream.resource(fn -> File.open!(input) end,
                    fn file ->
                      case IO.read(file, :line) do
                        data when is_binary(data) -> {[data], file}
                        _ -> {:halt, file}
                      end
                    end,
                    fn file -> File.close(file) end)
  end
end
