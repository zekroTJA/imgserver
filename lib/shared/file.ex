defmodule Imgserver.Shared.File do
  @spec get_extension(path :: Path.t()) :: String.t()
  def get_extension(path),
    do: path |> String.split(".") |> Enum.reverse() |> hd

  @spec get_mime_type(path :: Path.t()) :: String.t()
  def get_mime_type(path) do
    case get_extension(path) do
      "png" -> "image/png"
      "jpg" -> "image/jpeg"
      "jpeg" -> "image/jpeg"
      "jfif" -> "image/jpeg"
      "gif" -> "image/gif"
      _ -> "application/binary"
    end
  end
end
