defmodule Imgserver.Fs.Local do
  @behaviour Imgserver.Fs.FsBehaviour

  @moduledoc """
  TODO: Module and function docs
  """

  @rootpath Imgserver.Config.get_sub(FS, :root_location, ".")

  @impl Imgserver.Fs.FsBehaviour
  def ls!(path \\ "") do
    Path.join(@rootpath, path)
    |> File.ls!()
  end

  @impl Imgserver.Fs.FsBehaviour
  def get!(path) do
    full_path = Path.join(@rootpath, path)

    full_path
    |> File.stat!()
    |> Imgserver.Fs.File.from_stat(path, full_path)
  end
end
