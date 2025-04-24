defmodule NomifyWeb.Router do
  use NomifyWeb, :router

  import NomifyWeb.UserAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {NomifyWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_scope_for_user
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", NomifyWeb do
    pipe_through :browser

    get "/", PageController, :home
  end

  scope "/", NomifyWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :admin,
      on_mount: [{NomifyWeb.UserAuth, :mount_current_scope}] do
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
      live "/teams/:team_id/members/:id/role/edit", TeamMemberLive.RoleForm
      live "/teams/:team_id/members/:id/privileges/edit", TeamMemberLive.PrivilegesForm

      # documents
      live "/documents", DocumentLive.Index, :index
      live "/documents/new", DocumentLive.Form, :new
      live "/documents/:id", DocumentLive.Show, :show
      live "/documents/:id/edit", DocumentLive.Form, :edit

      # nominations
      live "/documents/:document_id/nominations/new", NominationLive.Form, :new
      live "/documents/:document_id/nominations/:id", NominationLive.Show, :show
      live "/documents/:document_id/nominations/:id/edit", NominationLive.Form, :edit
    end
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

  ## Authentication routes

  scope "/", NomifyWeb do
    pipe_through [:browser, :require_authenticated_user]

    live_session :require_authenticated_user,
      on_mount: [{NomifyWeb.UserAuth, :require_authenticated}] do
      live "/user/settings", UserLive.Settings, :edit
      live "/user/settings/confirm-email/:token", UserLive.Settings, :confirm_email
    end

    post "/user/update-password", UserSessionController, :update_password
  end

  scope "/", NomifyWeb do
    pipe_through [:browser]

    live_session :current_user,
      on_mount: [{NomifyWeb.UserAuth, :mount_current_scope}] do
      live "/user/register", UserLive.Registration, :new
      live "/user/log-in", UserLive.Login, :new
      live "/user/log-in/:token", UserLive.Confirmation, :new
    end

    post "/user/log-in", UserSessionController, :create
    delete "/user/log-out", UserSessionController, :delete
  end
end
