defmodule ForzaMatches.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ForzaMatches.Repo, 
      ForzaMatches.Scheduler
    ]
    
    opts = [strategy: :one_for_one, name: ForzaMatches.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
