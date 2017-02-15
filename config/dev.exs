# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :infuse,
    web_root: "www",
    start_server: true,
    start_observer: true,
    default_content_type: "text/plain"

config :logger,
    device: :standard_error

config :logger, :console,
  format: "\n$time $metadata[$level] $levelpad$message\n",
  device: :standard_error
