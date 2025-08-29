defmodule NectarineWeb.Router do
  use NectarineWeb, :router
  import Phoenix.LiveView.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {NectarineWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :graphql do
    plug :accepts, ["json"]
    plug NectarineWeb.Plugs.AuthGql
  end

  scope "/", NectarineWeb do
    pipe_through :browser

    live "/credit-application", CreditApplicationLive
  end

  scope "/api", NectarineWeb do
    pipe_through :api
  end

  scope "/graphql" do
    pipe_through :graphql

    forward "/", Absinthe.Plug,
      schema: NectarineWeb.Graphql.Schema,
      adapter: Absinthe.Adapter.LanguageConventions,
      document_providers: [Absinthe.Plug.DocumentProvider.Default]
  end

  # Enable LiveDashboard in development
  if Application.compile_env(:nectarine, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: NectarineWeb.Telemetry

      # Email preview
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
