defmodule Imgserver.Fs.Local do
  @behaviour Imgserver.Fs.FsBehaviour

  @moduledoc """
  TODO: Module and function docs
  """

  @impl Imgserver.Fs.FsBehaviour
  def ls!(path \\ ".") do
    File.ls!(path)
  end

  @impl Imgserver.Fs.FsBehaviour
  def get!(path) do
    File.stat!(path)
  end
end
