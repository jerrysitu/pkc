defmodule PeekChallenge.Repo do
  use Ecto.Repo,
    otp_app: :peek_challenge,
    adapter: Ecto.Adapters.Postgres
end
