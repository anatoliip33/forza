defmodule ForzaMatches.Repo.Migrations.CreateMatches do
  use Ecto.Migration

  def change do
    create table(:matches) do
      add :provider, :string, size: 20, null: false
      add :home_team, :string, size: 50, null: false
      add :away_team, :string, size: 50, null: false
      add :kickoff_at, :naive_datetime, null: false
      add :created_at, :integer, null: false

      timestamps(default: fragment("NOW()"))
    end
    
    create unique_index(:matches, [:provider, :home_team, :away_team, :kickoff_at])
  end
end
