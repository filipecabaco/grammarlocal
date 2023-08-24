defmodule GrammarlocalWeb.Router do
  use GrammarlocalWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {GrammarlocalWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", GrammarlocalWeb do
    pipe_through :browser

    live "/", InputLive
  end

  # Other scopes may use custom stacks.
  # scope "/api", GrammarlocalWeb do
  #   pipe_through :api
  # end
end
