defmodule Imgserver.Fs.FsBehaviour do
  @moduledoc """
  TODO: Module and function docs
  """
  @callback ls!(path :: Path.t()) :: list(String.t())
  @callback get(path :: Path.t()) :: {:ok, Imgserver.Fs.File.t()} | {:error, any()}
  @callback get!(path :: Path.t()) :: Imgserver.Fs.File.t()
end
