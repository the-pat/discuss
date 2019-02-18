# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :discuss,
  ecto_repos: [Discuss.Repo]

# Configures the endpoint
config :discuss, DiscussWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Kx1Mm/C78o8asXTBtnyET+tFdgvk1JGmdBLeQKfa4crN0NrjqnDiMs6vuKqNppRU",
  socket_secret_key: "I&aD$q5mFiK7",
  render_errors: [view: DiscussWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Discuss.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Use GitHub's Oauth
config :ueberauth, Ueberauth,
  providers: [github: {Ueberauth.Strategy.Github, []}]

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: "client_id",
  client_secret: "client_secret"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
