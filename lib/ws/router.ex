defmodule Imgserver.Ws.Router.AuthExclude do
  use Plug.Router
  import Imgserver.Ws.Util
  import Plug.Conn

  @moduledoc """
  Sub-router which is not affected by the authorization
  plug. This is mainly used for the login route.
  """

  @authmodule Imgserver.Config.get_sub(WS, :auth_module, Imgserver.Ws.Auth.Jwt)
  @authsub "default"
  @fsmodule Imgserver.Config.get_sub(FS, :module, Imgserver.Fs.Local)

  plug(:match)
  plug(:dispatch)

  # Login Route
  post "/api/auth/login" do
    password = Imgserver.Config.get_sub(WS, :password)

    if !password do
      conn |> resp_json_error(500, "no password was specified in the server config")
    end

    if conn.body_params["password"] != password do
      conn |> resp_json_unauthorized |> halt
    else
      case @authmodule.create_token(%{session_id: @authsub}) do
        {:ok, token} -> conn |> put_resp_cookie("__auth_key", token) |> resp_json_ok |> halt
        {:error, err} -> err |> resp_json_error(500, err) |> halt
      end
    end
  end

  get "/:name" do
    if name =~ ~r/^[\w\d-]+\.[\w\d]+$/ do
      case name |> @fsmodule.get do
        {:error, _err} ->
          conn |> resp_json_not_found |> halt

        {:ok, stat} ->
          case @fsmodule.get_data(stat.full_name) do
            {:error, err} ->
              conn |> resp_json_error(500, err) |> halt

            {:ok, data, mime} ->
              # TODO: Add caching headers
              conn
              |> put_resp_content_type(mime, nil)
              |> send_resp(200, data)
              |> halt
          end
      end
    else
      conn
    end
  end

  # Fallthough
  match _ do
    conn
  end
end

defmodule Imgserver.Ws.Router do
  require Logger
  import Imgserver.Ws.Util
  use Plug.Router
  use Plug.ErrorHandler

  @moduledoc """
  The main REST API Router and file server.
  """

  @fsmodule Imgserver.Config.get_sub(FS, :module, Imgserver.Fs.Local)

  plug(Plug.Parsers, parsers: [:json], pass: ["text/*"], json_decoder: Poison)
  plug(Imgserver.Ws.Router.AuthExclude)
  plug(Imgserver.Ws.Auth.Plug)
  plug(:match)
  plug(:dispatch)

  # List all image files
  get "/api/images" do
    @fsmodule.ls!()
    |> Enum.map(fn x -> @fsmodule.get!(x) end)
    |> resp_json(conn)
  end

  # Information about a specific image
  get "/api/images/:name" do
    case name |> @fsmodule.get do
      {:ok, stat} -> resp_json(stat, conn)
      {:error, _test} -> resp_json_not_found(conn)
    end
  end

  # Fallthrough
  match _ do
    resp_json_not_found(conn)
  end

  # Print log message with port information on startup
  Logger.info("WS running @ port #{Imgserver.Config.get_sub(WS, :port, 8080)}")

  # Error handler which handles matches throwing exceptions.
  defp handle_errors(conn, %{kind: _kind, reason: reason, stack: _stack}) do
    %Imgserver.Ws.Util.Error{
      code: 500,
      message: reason
    }
    |> resp_json_error(conn)
  end
end
