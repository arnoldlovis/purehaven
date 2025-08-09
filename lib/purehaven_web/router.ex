defmodule PurehavenWeb.Router do
  use PurehavenWeb, :router

  import PurehavenWeb.AdminAuth

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {PurehavenWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_current_admin
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PurehavenWeb do
    pipe_through :browser

    get "/", PageController, :home
    get "/home", PageController, :home
    get "/products", PageController, :products
    get "/products/new-products", ProductController, :new_products
    get "/products/private-label", ProductController, :private_label
    get "/aboutus", PageController, :aboutus
    get "/contactus", PageController, :contactus
    get "/faqs", PageController, :faqs
    get "/reviews", PageController, :reviews
    post "/send_message", PageController, :send_message
    post "/submit_review", PageController, :submit_review
    post "/subscribe", PageController, :subscribe
    post "/submit_distributor", PageController, :submit_distributor
    live "/newsletter", NewsletterLive
    live "/test_live", TestLive
  end

  # Enable LiveDashboard and Mailbox Preview in dev
  if Application.compile_env(:purehaven, :dev_routes) do
    import Phoenix.LiveDashboard.Router

    scope "/dev" do
      pipe_through :browser
      live_dashboard "/dashboard", metrics: PurehavenWeb.Telemetry
      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end

  ## Admin authentication routes

  scope "/", PurehavenWeb do
    pipe_through [:browser, :redirect_if_admin_is_authenticated]

    live_session :redirect_if_admin_is_authenticated,
      on_mount: [{PurehavenWeb.AdminAuth, :redirect_if_admin_is_authenticated}] do
      live "/admins/log_in", AdminLoginLive, :new
      live "/admins/reset_password", AdminForgotPasswordLive, :new
      live "/admins/reset_password/:token", AdminResetPasswordLive, :edit
    end

    post "/admins/log_in", AdminSessionController, :create
  end

 # Admin protected settings and management
scope "/", PurehavenWeb do
  pipe_through [:browser, :require_authenticated_admin]

  live_session :require_authenticated_admin,
    on_mount: [{PurehavenWeb.AdminAuth, :ensure_authenticated}] do
    # Settings
    live "/admins/settings", AdminSettingsLive, :edit
    live "/admins/settings/confirm_email/:token", AdminSettingsLive, :confirm_email

    # Dashboard & Admin Panels
    live "/admin/dashboard", AdminDashboardLive
    live "/admin/reviews", AdminReviewLive
    live "/admin/messages", AdminMessageLive
    live "/admin/subscribers", AdminSubscriberLive
    live "/admin/newsletter/send", AdminNewsletterSendLive
    live "/admin/inputs", AdminInputLive
    live "/admin/distributors", AdminDistributorLive
    live "admin/distributors/export", DistributorController
  end
end

  # Logout and confirmation
  scope "/", PurehavenWeb do
    pipe_through [:browser]

    delete "/admins/log_out", AdminSessionController, :delete

    live_session :current_admin,
      on_mount: [{PurehavenWeb.AdminAuth, :mount_current_admin}] do
      live "/admins/confirm/:token", AdminConfirmationLive, :edit
      live "/admins/confirm", AdminConfirmationInstructionsLive, :new
    end
  end
end
