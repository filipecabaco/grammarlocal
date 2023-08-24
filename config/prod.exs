import Config

config :grammarlocal, GrammarlocalWeb.Endpoint,
  cache_static_manifest: "priv/static/cache_manifest.json"

config :grammarlocal, GrammarlocalWeb.Endpoint,
  server: true,
  secret_key_base: 20 |> :crypto.strong_rand_bytes() |> Base.encode64()

config :logger, level: :error
