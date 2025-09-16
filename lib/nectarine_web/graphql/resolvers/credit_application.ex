defmodule NectarineWeb.Graphql.Resolvers.CreditApplication do
  @moduledoc """
  GraphQL resolvers for credit application operations.
  
  Handles credit application creation, retrieval, and email notifications.
  """
  
  alias Nectarine.CreditApplications
  alias Nectarine.Mailer
  alias Nectarine.Email
  require Logger

  @doc """
  Creates a new credit application and sends approval email if approved.
  """
  def create(_parent, %{input: params}, _resolution) do
    case CreditApplications.create_credit_application(params) do
      {:ok, application} ->
        handle_approved_application(application)

      {:error, _changeset} ->
        {:ok, %{message: "Validation failed"}}
    end
  end

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
  def get(_parent, %{id: id}, _resolution) do
    case CreditApplications.get_credit_application(id) do
      nil -> {:error, "Not found"}
      application -> {:ok, application}
    end
  end

  # Sends approval email for approved credit applications.
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
