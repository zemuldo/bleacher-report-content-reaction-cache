defmodule BleacherReportWeb.Router do
  use BleacherReportWeb, :router

  pipeline :browser do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :auth do
    plug BleacherReport.Auth.ApiUserPlug
  end

  scope "/", BleacherReportWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/api", BleacherReportWeb do
    pipe_through [:api, :auth]

    post "/reaction", ReactionsController, :new_update
    get "/reaction_counts/:content_id", ReactionsController, :content_reactions
  end
end
