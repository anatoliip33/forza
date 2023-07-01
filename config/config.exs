import Config

config :forza_matches, ecto_repos: [ForzaMatches.Repo]

config :forza_matches, ForzaMatches.Repo,
  database: "forza",
  username: "anatolii",
  password: "football",
  hostname: "localhost"

config :logger, level: :debug

config :forza_matches, ForzaMatches.Scheduler, 
  jobs: [
    # Every 30 seconds
    {{:extended, "15-59/30 * * * *"}, {ForzaMatches.Matches, :insert_matches_to_db, ["matchbeam"]}},
    {{:extended, "5-59/30 * * * *"}, {ForzaMatches.Matches, :insert_matches_to_db, ["fastball"]}},
  ]