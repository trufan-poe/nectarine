defmodule Nectarine.Factory do
  @moduledoc """
  Test data factories for ExMachina.
  """
  use ExMachina.Ecto, repo: Nectarine.Repo

  alias Nectarine.CreditApplications.CreditApplication

  def credit_application_factory do
    %CreditApplication{
      has_job: true,
      job_12_months: true,
      owns_home: true,
      owns_car: false,
      additional_income: false,
      monthly_income: "5000.00",
      monthly_expenses: "2000.00",
      email: Faker.Internet.email()
    }
  end
end
