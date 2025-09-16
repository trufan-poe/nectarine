defmodule NectarineWeb.Graphql.Schema.Error do
  @moduledoc """
  Error type definition for GraphQL responses.
  
  Used to represent error states in GraphQL operations.
  """
  
  defstruct [:message]
end
