defmodule NectarineWeb.Plugs.AuthGql do
  @moduledoc """
  Authentication plug for GraphQL endpoints.
  Currently just logs authentication completion.
  """
  require Logger

  def init(opts), do: opts

  def call(conn, _opts) do
    Logger.info("Auth done here")
    conn
  end
end
