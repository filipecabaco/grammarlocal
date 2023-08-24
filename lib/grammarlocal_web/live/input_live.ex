defmodule GrammarlocalWeb.InputLive do
  use GrammarlocalWeb, :live_view

  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:output, "")
      |> assign(:input, "")
      |> assign(:loading, false)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <textarea
        phx-blur="run"
        class="rounded-xl border border-slate-200 shadow w-full h-auto p-3 resize-none mb-10"
        rows="10"
      ><%= @input %></textarea>
      <div :if={@loading} class="w-full flex justify-center">
        <img src={~p"/images/loading.png"} class="animate-spin-slow" width="42" />
      </div>
      <div :if={!@loading} class="w-full p-3"><%= @output %></div>
    </div>
    """
  end

  def handle_event("run", %{"value" => value}, socket) do
    Task.async(fn -> Nx.Serving.batched_run({:local, Grammarlocal.Serving}, value) end)
    {:noreply, socket |> assign(:input, value) |> assign(:loading, true)}
  end

  def handle_info({_, %{results: [%{text: text}]}}, socket) do
    {:noreply, socket |> assign(:output, text) |> assign(:loading, false)}
  end

  def handle_info({:DOWN, _, _, _, :normal}, socket), do: {:noreply, socket}
end
