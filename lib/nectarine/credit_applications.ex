defmodule Nectarine.CreditApplications do
  @moduledoc """
  The CreditApplications context.
  """

  import Ecto.Query, warn: false
  alias Nectarine.Repo
  alias Nectarine.CreditApplications.CreditApplication

  @doc """
  Returns the list of credit_applications.
  """
  def list_credit_applications do
    Repo.all(CreditApplication)
  end

  @doc """
  Gets a single credit_application.
  """
  def get_credit_application!(id), do: Repo.get!(CreditApplication, id)

  @doc """
  Gets a single credit_application by id.
  """
  def get_credit_application(id), do: Repo.get(CreditApplication, id)

  @doc """
  Creates a credit_application.
  """
  def create_credit_application(attrs \\ %{}) do
    %CreditApplication{}
    |> CreditApplication.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a credit_application.
  """
  def update_credit_application(%CreditApplication{} = credit_application, attrs) do
    credit_application
    |> CreditApplication.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a credit_application.
  """
  def delete_credit_application(%CreditApplication{} = credit_application) do
    Repo.delete(credit_application)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking credit_application changes.
  """
  def change_credit_application(%CreditApplication{} = credit_application, attrs \\ %{}) do
    CreditApplication.changeset(credit_application, attrs)
  end
end
