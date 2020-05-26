import Config

config :imgserver, WS,
  scheme: :http,
  port: 8080,
  auth_module: Imgserver.Ws.Auth.Jwt,
  password: "test123"

config :imgserver, FS,
  module: Imgserver.Fs.Local,
  root_location: "./data"

config :imgserver, Imgserver.Ws.Auth.Jwt.Guardian,
  issuer: "image server",
  secret_key: "my-secret-key"
