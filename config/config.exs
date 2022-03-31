# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :peek_challenge,
  ecto_repos: [PeekChallenge.Repo]

# Configures the endpoint
config :peek_challenge, PeekChallengeWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: PeekChallengeWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: PeekChallenge.PubSub,
  live_view: [signing_salt: "90u8xPY6"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
