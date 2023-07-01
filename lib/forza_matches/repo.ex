defmodule ForzaMatches.Repo do
  use Ecto.Repo,
    otp_app: :forza_matches,
    adapter: Ecto.Adapters.Postgres
end
