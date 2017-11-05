# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :infuse,
    web_root: "test/fake-www",
    start_server: false,
    start_observer: false,
    default_content_type: "text/plain"