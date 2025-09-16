defmodule NectarineWeb.Graphql.Resolvers.CreditApplication do
  @moduledoc """
  GraphQL resolvers for credit application operations.
  
  Handles credit application creation, retrieval, and email notifications.
  """
  
  alias Nectarine.CreditApplications
  alias Nectarine.Mailer
  alias Nectarine.Email
  require Logger

  @type create_result :: {:ok, map()} | {:error, String.t()}
  @type get_result :: {:ok, CreditApplications.CreditApplication.t()} | {:error, String.t()}

  @doc """
  Creates a new credit application and sends approval email if approved.
  """
  @spec create(any(), %{input: map()}, any()) :: create_result()
  def create(_parent, %{input: params}, _resolution) do
    case CreditApplications.create_credit_application(params) do
      {:ok, application} ->
        handle_approved_application(application)

      {:error, _changeset} ->
        {:ok, %{message: "Validation failed"}}
    end
  end

  @spec handle_approved_application(CreditApplications.CreditApplication.t()) :: create_result()
  defp handle_approved_application(application) do
    if application.status == "approved" do
      # TODO: Consider using Oban or another task runner for more robust
      # background job processing with retries and persistence
      Task.async(fn -> send_approval_email(application) end)
    end

    {:ok, application}
  end

  @doc """
  Retrieves a credit application by ID.
  """
  @spec get(any(), %{id: integer()}, any()) :: get_result()
  def get(_parent, %{id: id}, _resolution) do
    case CreditApplications.get_credit_application(id) do
      nil -> {:error, "Not found"}
      application -> {:ok, application}
    end
  end

  # Sends approval email for approved credit applications.
  @spec send_approval_email(CreditApplications.CreditApplication.t()) :: :ok
  defp send_approval_email(application) do
    email =
      application
      |> Email.approval_email()

    Logger.info("Sending email to #{application.email}")

    case Mailer.deliver(email) do
      {:ok, resp} -> Logger.info("Email sent: #{inspect(resp)}")
      {:error, reason} -> Logger.error("Email failed: #{inspect(reason)}")
    end
  end
end
