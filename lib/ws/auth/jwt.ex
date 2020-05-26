defmodule Imgserver.Ws.Auth.Jwt.Guardian do
  use Guardian, otp_app: :imgserver
  alias Imgserver.Ws.Auth.Resource

  @moduledoc """
  Guardian specification for JWTs.
  """

  def subject_for_token(resource, _claims) do
    sub = resource.session_id
    {:ok, sub}
  end

  def resource_from_claims(claims) do
    rc = %Resource{
      session_id: claims["sub"]
    }

    {:ok, rc}
  end
end

defmodule Imgserver.Ws.Auth.Jwt do
  alias Imgserver.Ws.Auth.Jwt.Guardian
  @behaviour Imgserver.Ws.Auth.AuthBehaviour

  @moduledoc """
  AuthBehaviour implementation with
  JSON Web Tokens (JWTs).
  """

  def create_token(resource) do
    case Guardian.encode_and_sign(resource) do
      {:ok, token, _claims} -> {:ok, token}
      {:error, err} -> {:error, err}
    end
  end

  def check_token(token) do
    case Guardian.resource_from_token(token) do
      {:ok, resource, _claims} -> {:ok, resource}
      {:error, err} -> {:error, err}
    end
  end
end
