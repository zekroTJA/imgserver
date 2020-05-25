import Config

config :imgserver, WS,
  scheme: :http,
  port: 8081

config :imgserver, FS,
  module: Imgserver.Fs.Local,
  root_location: "./data"
