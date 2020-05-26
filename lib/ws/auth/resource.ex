defmodule Imgserver.Ws.Auth.Resource do
  @moduledoc """
  Holds information about the authenticated
  session or user.
  """

  @type t :: %__MODULE__{
          session_id: String.t()
        }

  defstruct session_id: ""
end
