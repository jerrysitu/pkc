defmodule PeekChallengeWeb.Router do
  use PeekChallengeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PeekChallengeWeb do
    pipe_through :api
  end
end
