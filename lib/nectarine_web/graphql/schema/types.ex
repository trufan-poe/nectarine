defmodule NectarineWeb.Graphql.Schema.Types do
  @moduledoc """
  GraphQL type definitions for the credit application system.
  
  Defines custom scalar types and input/output types for GraphQL operations.
  """
  
  use Absinthe.Schema.Notation

  scalar :decimal do
    parse(fn
      %{value: value} ->
        case Decimal.parse(to_string(value)) do
          # accepted only if the whole string parsed
          {d, ""} -> {:ok, d}
          _ -> :error
        end

      _ ->
        :error
    end)

    serialize(&Decimal.to_string/1)
  end

  scalar :naive_datetime do
    parse(fn
      %{value: value}, _ -> NaiveDateTime.from_iso8601(value)
      _, _ -> :error
    end)

    serialize(&NaiveDateTime.to_iso8601/1)
  end

  object :credit_application do
    field :id, :id
    field :has_job, :boolean
    field :job_12_months, :boolean
    field :owns_home, :boolean
    field :owns_car, :boolean
    field :additional_income, :boolean
    field :risk_score, :integer
    field :monthly_income, :decimal
    field :monthly_expenses, :decimal
    field :approved_amount, :decimal
    field :email, :string
    field :status, :string
    field :inserted_at, :naive_datetime
  end

  input_object :credit_application_input do
    field :has_job, non_null(:boolean)
    field :job_12_months, non_null(:boolean)
    field :owns_home, non_null(:boolean)
    field :owns_car, non_null(:boolean)
    field :additional_income, non_null(:boolean)
    field :monthly_income, :decimal
    field :monthly_expenses, :decimal
    field :email, :string
  end

  union :credit_application_result do
    types([:credit_application, :error])

    resolve_type(fn
      %{__struct__: Nectarine.CreditApplications.CreditApplication}, _ -> :credit_application
      %{__struct__: NectarineWeb.Graphql.Schema.Error}, _ -> :error
    end)
  end

  object :error do
    field :message, :string
  end
end
