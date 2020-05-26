defmodule Imgserver.Ws.Auth.Plug do
  import Plug.Conn
  import Imgserver.Ws.Util
  @behaviour Plug

  @moduledoc """
  Plug providing authentication using the configured
  authorization module and HTTP cookies.
  """

  @authmodule Imgserver.Config.get_sub(WS, :auth_module, Imgserver.Ws.Auth.Jwt)
  @authsub "default"

  def init(opts), do: opts

  def call(conn, _opts) do
    conn = conn |> fetch_cookies
    token = conn.cookies["__auth_key"]

    if !token do
      conn |> resp_json_unauthorized |> halt
    else
      case @authmodule.check_token(token) do
        {:ok, resource} -> conn |> check_resource_sub(resource) |> assign(:resource, resource)
        {:error, _err} -> conn |> resp_json_unauthorized |> halt
      end
    end
  end

  defp check_resource_sub(conn, resource) do
    if resource.session_id != @authsub do
      IO.inspect(resource)
      conn |> resp_json_unauthorized |> halt
    else
      conn
    end
  end
end
