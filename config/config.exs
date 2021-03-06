# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :bleacher_report, BleacherReportWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "SGe2XPg+ZfNXO8PuddHWTPohUxYCaW+WmTE0KVt6rybpeEQBvO76aW8xOi9oaAs1",
  api_auth_salt: "PohUxYCaW+WmTE0KVt6rybpeEQBvO763JxBMO0QlZjoe4sQnIIzdg88GQXhVmp1KS0",
  render_errors: [view: BleacherReportWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: BleacherReport.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.

config :bleacher_report, BleacherReport.Cache,
  user_reactions_table: :user_reaction,
  reactions_counter_table: :reaction_count

import_config "#{Mix.env()}.exs"
