defmodule NectarineWeb.Graphql.Client do
  @moduledoc """
  GraphQL client helper functions for testing.
  """

  import Plug.Conn
  import Phoenix.ConnTest
  @endpoint NectarineWeb.Endpoint

  def query(conn, gql, vars \\ %{}) do
    response =
      post(
        conn,
        "/graphql",
        %{
          query: gql,
          variables: vars
        }
      )

    Jason.decode!(response.resp_body)
  end

  def query!(conn, gql, vars \\ %{}) do
    case query(conn, gql, vars) do
      %{"errors" => [%{"message" => message} | _t]} ->
        raise message

      %{"data" => data} ->
        data
    end
  end

  # Backward compatibility functions with different names
  def query_with_build_conn(gql, vars \\ %{}) do
    conn = build_conn()
    query(conn, gql, vars)
  end

  def query_with_build_conn!(gql, vars \\ %{}) do
    conn = build_conn()
    query!(conn, gql, vars)
  end
end
