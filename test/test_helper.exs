ExUnit.start()

# Set up the test database
Ecto.Adapters.SQL.Sandbox.mode(Nectarine.Repo, :manual)

# Ensure the application is started and database is migrated
Application.ensure_all_started(:nectarine)

# Only start the repo if it's not already running
case Nectarine.Repo.start_link() do
  {:ok, _pid} -> :ok
  {:error, {:already_started, _pid}} -> :ok
end

# GraphQL client is loaded automatically with the test support files
