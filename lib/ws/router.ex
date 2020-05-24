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

  match _ do
    conn |> resp_json_not_found
  end

  # Print log message with port information on startup
  Logger.info("WS running @ port #{Application.get_env(:imgserver, :ws_port, 8080)}")
end
