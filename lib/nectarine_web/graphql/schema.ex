defmodule NectarineWeb.Graphql.Schema do
  @moduledoc """
  Main GraphQL schema definition for the credit application system.
  
  Defines queries, mutations, and imports type definitions.
  """
  
  use Absinthe.Schema
  import_types(NectarineWeb.Graphql.Schema.Types)

  query do
    field :credit_application, :credit_application do
      arg(:id, :id)
      resolve(&NectarineWeb.Graphql.Resolvers.CreditApplication.get/3)
    end
  end

  mutation do
    field :create_credit_application, :credit_application_result do
      arg(:input, non_null(:credit_application_input))
      resolve(&NectarineWeb.Graphql.Resolvers.CreditApplication.create/3)
    end
  end
end
