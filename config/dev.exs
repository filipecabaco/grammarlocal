import Config

config :grammarlocal, GrammarlocalWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "6T+gO6DWZSXgx8DPMBNPpdauAJ8g2XB9JNYk2Zn7K+/4Jp5tf0Z/o1+kloRHhj/d",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]},
    tailwind: {Tailwind, :install_and_run, [:default, ~w(--watch)]}
  ]

config :grammarlocal, GrammarlocalWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"lib/grammarlocal_web/(controllers|live|components)/.*(ex|heex)$"
    ]
  ]

config :grammarlocal, dev_routes: true

config :logger, :console, format: "[$level] $message\n"

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime
