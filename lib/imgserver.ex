defmodule Imgserver.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  import Imgserver.Config
  use Application

  def start(_type, _args) do
    children = [
      {Plug.Cowboy,
       plug: Imgserver.Ws.Router,
       scheme: get_sub(WS, :scheme, :http),
       options: [port: get_sub(WS, :port, 8080)]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Imgserver.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
