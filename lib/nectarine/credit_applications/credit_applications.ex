defmodule Nectarine.CreditApplications.CreditApplication do
  @moduledoc """
  Ecto schema for credit applications.
  
  Defines the database structure and validation rules for credit applications,
  including risk scoring and approval logic.
  """
  
  use Ecto.Schema
  import Ecto.Changeset

  schema "credit_applications" do
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
    field :status, :string, default: "pending"

    timestamps()
  end

  def changeset(credit_application, attrs) do
    credit_application
    |> cast(attrs, [
      :has_job,
      :job_12_months,
      :owns_home,
      :owns_car,
      :additional_income,
      :monthly_income,
      :monthly_expenses,
      :email
    ])
    |> validate_required([:has_job, :job_12_months, :owns_home, :owns_car, :additional_income])
    |> calculate_risk_score()
    |> calculate_approved_amount()
  end

  defp calculate_risk_score(changeset) do
    score =
      if(get_field(changeset, :has_job), do: 4, else: 0) +
        if(get_field(changeset, :job_12_months), do: 2, else: 0) +
        if(get_field(changeset, :owns_home), do: 2, else: 0) +
        if(get_field(changeset, :owns_car), do: 1, else: 0) +
        if get_field(changeset, :additional_income), do: 2, else: 0

    put_change(changeset, :risk_score, score)
  end

  defp calculate_approved_amount(changeset) do
    case get_field(changeset, :risk_score) do
      score when score > 6 ->
        income = get_field(changeset, :monthly_income) || Decimal.new(0)
        expenses = get_field(changeset, :monthly_expenses) || Decimal.new(0)
        approved = Decimal.mult(Decimal.sub(income, expenses), Decimal.new(12))

        changeset
        |> put_change(:approved_amount, approved)
        |> put_change(:status, "approved")

      _ ->
        changeset
        |> put_change(:status, "rejected")
        |> put_change(:approved_amount, nil)
    end
  end
end
