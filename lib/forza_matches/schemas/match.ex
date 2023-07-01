defmodule ForzaMatches.Match do
  use Ecto.Schema
  import Ecto.Changeset
  
  schema "matches" do
    field :provider, :string
    field :home_team, :string
    field :away_team, :string
    field :kickoff_at, :naive_datetime
    field :created_at, :integer
  end
  
  def changeset(match, attrs) do
    match
    |> cast(attrs, [:provider, :home_team, :away_team, :kickoff_at, :created_at])
    |> validate_required([:provider, :home_team, :away_team, :kickoff_at, :created_at])
  end
end