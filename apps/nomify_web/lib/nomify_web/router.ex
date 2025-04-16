defmodule NomifyWeb.Router do
  use NomifyWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {NomifyWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NomifyWeb do
    pipe_through :browser

    get "/", PageController, :home

    # people
    live "/people", PersonLive.Index, :index
    live "/people/new", PersonLive.Form, :new
    live "/people/:id", PersonLive.Show, :show
    live "/people/:id/edit", PersonLive.Form, :edit

    # teams
    live "/teams", TeamLive.Index, :index
    live "/teams/new", TeamLive.Form, :new
    live "/teams/:id", TeamLive.Show, :show
    live "/teams/:id/edit", TeamLive.Form, :edit

    live "/teams/:team_id/members/new", TeamMemberLive.Form, :new
    live "/teams/:team_id/members/:id", TeamMemberLive.Show, :show
    live "/teams/:team_id/members/:id/edit", TeamMemberLive.Form, :edit
    live "/teams/:team_id/members/:id/team_role/edit", TeamMemberLive.TeamRoleForm
    live "/teams/:team_id/members/:id/privileges/edit", TeamMemberLive.PrivilegesForm

    # documents
    live "/documents", DocumentLive.Index, :index
    live "/documents/new", DocumentLive.Form, :new
    live "/documents/:id", DocumentLive.Show, :show
    live "/documents/:id/edit", DocumentLive.Form, :edit
  end

  # Other scopes may use custom stacks.
  # scope "/api", NomifyWeb do
  #   pipe_through :api
  # end

  # Enable LiveDashboard and Swoosh mailbox preview in development
  if Application.compile_env(:nomify_web, :dev_routes) do
    # If you want to use the LiveDashboard in production, you should put
    # it behind authentication and allow only admins to access it.
    # If your application does not have an admins-only section yet,
    # you can use Plug.BasicAuth to set up some basic authentication
    # as long as you are also using SSL (which you should anyway).
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: NomifyWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
