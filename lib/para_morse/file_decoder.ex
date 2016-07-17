defmodule ParaMorse.FileDecoder do
  @doc ~S"""
  Reads an `input` file with alphanumeric characters and writes an `output` file
  encoded in morse.

  ## Examples

   iex> String.graphemes("line 1\n and line 2\n and line 3") |>
   iex> Stream.into(File.stream!("sample.txt")) |>
   iex> Stream.run
   :ok
   iex> ParaMorse.FileEncoder.encode("sample.txt", "encoded.txt")
   iex> ParaMorse.FileDecoder.decode("encoded.txt", "decoded.txt")
   iex> File.stream!("decoded.txt")
   iex> |> Enum.to_list
   iex> |> Enum.join("")
   "line 1 and line 2 and line 3"
   iex> File.rm("sample.txt")
   iex> File.rm("encoded.txt")
   iex> File.rm("decoded.txt")
   :ok

  """
  def decode(input, output) do
    file_stream(input)
    |> Stream.map(&ParaMorse.Encoder.decode(&1))
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
