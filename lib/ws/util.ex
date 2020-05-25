defmodule Imgserver.Ws.Util do
  import Plug.Conn

  @moduledoc """
  Module that provides some basic functionalities
  for sending and responding to HTTP requests.
  """

  defmodule Error do
    @moduledoc """
    A struct wrapping an error repsonse
    object containing a `code` and an
    error `message`.
    """

    @type t() :: %Imgserver.Ws.Util.Error{
            code: integer(),
            message: String.t()
          }

    defstruct code: 0, message: ""
  end

  @doc """
  Respond with the passed `object` as JSON
  body content and `status` as response
  status code.
  """
  def resp_json(object, conn, status \\ 200) do
    conn
    |> put_resp_content_type("application/json", "utf-8")
    |> send_resp(status, Poison.encode!(object))
  end

  @doc """
  Respond with a JSON parsed `err` object
  wrapping the error code (equals status code)
  and an error message.
  """
  def resp_json_error(err, conn) do
    err
    |> resp_json(conn, err.code)
  end

  @doc """
  Wraps `resp_json_error/2` with a predefined
  404 not found error object.
  """
  def resp_json_not_found(conn) do
    conn
    |> resp_json_error(%Error{code: 404, message: "not found"})
  end
end
