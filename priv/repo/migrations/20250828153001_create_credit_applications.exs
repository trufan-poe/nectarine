defmodule Nectarine.Repo.Migrations.CreateCreditApplications do
  use Ecto.Migration

  def change do
    create table(:credit_applications) do
      add :has_job, :boolean, null: false
      add :job_12_months, :boolean, null: false
      add :owns_home, :boolean, null: false
      add :owns_car, :boolean, null: false
      add :additional_income, :boolean, null: false
      add :risk_score, :integer
      add :monthly_income, :decimal, precision: 10, scale: 2
      add :monthly_expenses, :decimal, precision: 10, scale: 2
      add :approved_amount, :decimal, precision: 10, scale: 2
      add :email, :string
      add :status, :string, default: "pending"

      timestamps()
    end

    create index(:credit_applications, [:email])
    create index(:credit_applications, [:status])
    create index(:credit_applications, [:risk_score])
  end
end
