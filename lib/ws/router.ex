defmodule Imgserver.Ws.Router do
  require Logger
  import Imgserver.Ws.Util
  use Plug.Router

  @moduledoc """
  The main REST API Router and file server.
  """

  plug(:match)
  plug(:dispatch)
  plug(Plug.Parsers, parsers: [:json], pass: ["text/*"], json_decoder: Poison)

  get "/api/images" do
    fsmodule().ls!()
    |> Enum.map(fn x -> fsmodule().get!(x) end)
    |> resp_json(conn)
  end

  match _ do
    resp_json_not_found(conn)
  end

  # Print log message with port information on startup
  Logger.info("WS running @ port #{Imgserver.Config.get_sub(WS, :port, 8080)}")

  defp fsmodule do
    Imgserver.Config.get_sub(FS, :module, Imgserver.Fs.Local)
  end
end
