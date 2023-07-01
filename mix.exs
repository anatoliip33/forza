defmodule ForzaMatches.MixProject do
  use Mix.Project

  def project do
    [
      app: :forza_matches,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      elixirc_options: [
        warnings_as_errors: true
      ],
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ForzaMatches.Application, []}
    ]
  end
  
  defp deps do
    [
      {:ecto_sql, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:httpoison, "~> 2.0"},
      {:jason, "~> 1.3"},
      {:quantum, "~> 3.0"}
    ]
  end
end
