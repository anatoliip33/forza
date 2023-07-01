defmodule ForzaMatches.FetchMatches do
  def fetch(provider, last_checked_at) do
    matches_url(provider, last_checked_at)
    |> HTTPoison.get()
    |> handle_response()
  end

  def matches_url(provider, last_checked_at) do
    "http://forzaassignment.forzafootball.com:8080/feed/#{provider}/#{last_checked_at && "?last_checked_at=#{last_checked_at+1}"}"
  end

  def handle_response({:ok, %{status_code: 200, body: body}}) do
    body 
    |> Jason.decode()
  end

  def handle_response({_, %{status_code: 400, body: _}}) do
    {:error, "query parameters are invalid"}
  end

  def handle_response({_, %{status_code: 503, body: _}}) do
    {:error, "service is temporarily unavailable"}
  end

  def handle_response({_, %{status_code: _, body: body}}) do
    {:error, body}
  end

  def handle_response({_, %HTTPoison.Error{reason: reason}}) do
    {:error, reason}
  end
end