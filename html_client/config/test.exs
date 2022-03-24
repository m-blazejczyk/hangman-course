import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :html_client, HtmlClientWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "klmxgksLDmq5BnZz8eHovBALVXfol9AZw/SVB74Zyeez3Z317rJS2I9sp3l41bLl",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
