defmodule Imgserver.Fs.Local do
  alias Imgserver.Fs.FsBehaviour, as: FsBehaviour
  @behaviour FsBehaviour

  @moduledoc """
  TODO: Module and function docs
  """

  @rootpath Imgserver.Config.get_sub(FS, :root_location, ".")

  @impl FsBehaviour
  def ls!(path \\ "") do
    Path.join(@rootpath, path)
    |> File.ls!()
  end

  @impl FsBehaviour
  def get(path) do
    full_path = Path.join(@rootpath, path)

    case full_path |> File.stat() do
      {:ok, stat} -> {:ok, Imgserver.Fs.File.from_stat(stat, path, full_path)}
      {:error, posix} -> {:error, posix}
    end
  end

  @impl FsBehaviour
  def get!(path) do
    full_path = Path.join(@rootpath, path)

    full_path
    |> File.stat!()
    |> Imgserver.Fs.File.from_stat(path, full_path)
  end
end
