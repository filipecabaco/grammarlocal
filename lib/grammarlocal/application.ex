defmodule Grammarlocal.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    Nx.global_default_backend(EXLA.Backend)
    {:ok, model} = Bumblebee.load_model({:hf, "grammarly/coedit-large"})
    {:ok, tokenizer} = Bumblebee.load_tokenizer({:hf, "grammarly/coedit-large"})

    {:ok, generation_config} = Bumblebee.load_generation_config({:hf, "grammarly/coedit-large"})

    generation_config = %{generation_config | max_new_tokens: 1500}

    serving =
      Bumblebee.Text.generation(model, tokenizer, generation_config,
        defn_options: [compiler: EXLA]
      )

    children = [
      GrammarlocalWeb.Telemetry,
      {Phoenix.PubSub, name: Grammarlocal.PubSub},
      GrammarlocalWeb.Endpoint,
      {Nx.Serving, serving: serving, name: Grammarlocal.Serving, batch_timeout: 100}
    ]

    opts = [strategy: :one_for_one, name: Grammarlocal.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @impl true
  @spec config_change(any, any, any) :: :ok
  def config_change(changed, _new, removed) do
    GrammarlocalWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
