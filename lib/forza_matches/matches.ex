defmodule ForzaMatches.Matches do
  @moduledoc """
  The Matches context.
  """
  alias ForzaMatches.{Repo, FetchMatches, Match}

  import Ecto.Query

  require Logger

  def insert_matches_to_db(provider, last_checked_at \\ nil) do
    case FetchMatches.fetch(provider, last_checked_at) do
      {:ok, %{"matches" => matches}} ->
        latest_db_timestamp =
          provider
          |> get_match_latest_timestamp()
          
        matches
        |> Enum.filter(& &1["created_at"] > latest_db_timestamp)
        |> Enum.map(& 
          parse_match(&1)
          |> form_match_for_insert_to_db(provider)
        )
        |> Enum.filter(& &1)
        |> Enum.chunk_every(1000)
        |> Enum.each(fn chunk ->
          Repo.insert_all(Match, chunk)
        end)

      {:error, response} -> 
        response
        
      _ -> 
        "unknown mistake"  
    end
  end

  def parse_match(%{
    "home_team" => home_team,
    "away_team" => away_team,
    "kickoff_at" => kickoff_at,
    "created_at" => created_at
  }) do
    {:ok, {home_team, away_team, kickoff_at, created_at}}
  end

  def parse_match(%{
    "teams" => teams,
    "kickoff_at" => kickoff_at,
    "created_at" => created_at
  }) do
    [home_team, away_team] =
      teams
      |> String.split(" - ")

    {:ok, {home_team, away_team, kickoff_at, created_at}}
  end

  def parse_match(match) do
    {:error, "unable to parse match with keys #{match |> Map.keys() |> Enum.join(",")}"}
  end

  def form_match_for_insert_to_db({:ok, {home_team, away_team, kickoff_at, created_at}}, provider) do
    %{
      provider: provider,
      home_team: home_team,
      away_team: away_team,
      kickoff_at: kickoff_at |> NaiveDateTime.from_iso8601!(),
      created_at: created_at
    }
  end

  def form_match_for_insert_to_db({:error, error}, provider) do
    Logger.error("#{error} for #{provider}")
    
    nil
  end

  def get_match_latest_timestamp(provider) do
    Repo.one(
      from match in Match,
        where: match.provider == ^provider,
        order_by: [desc: match.created_at], 
        limit: 1,
        select: match.created_at
    ) || 0
  end
end