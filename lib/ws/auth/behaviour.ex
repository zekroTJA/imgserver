defmodule Imgserver.Ws.Auth.AuthBehaviour do
  alias Imgserver.Ws.Auth.Resource

  @moduledoc """
  Describes an authorization module which provides
  basic functionalities to create a session key to
  and from a resource.
  """

  @callback create_token(resource :: Resource.t()) ::
              {:ok, token :: String.t()}
              | {:error, err :: any()}

  @callback check_token(token :: String.t()) ::
              {:ok, resource :: Resource.t()}
              | {:error, err :: any()}
end
