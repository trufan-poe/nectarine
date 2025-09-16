defmodule NectarineWeb.Graphql.Resolvers.CreditApplication do
  alias Nectarine.CreditApplications
  alias Nectarine.Mailer
  alias Nectarine.Email
  require Logger

  def create(_parent, %{input: params}, _resolution) do
    case CreditApplications.create_credit_application(params) do
      {:ok, application} ->
        # Always return the application, whether approved or rejected
        # Only send email for approved applications
        # TODO: Consider using Oban or another task runner for more robust
        # background job processing with retries and persistence
        if application.status == "approved" do
          Task.async(fn -> send_approval_email(application) end)
        end

        {:ok, application}

      {:error, _changeset} ->
        # Return validation errors as an error object
        {:ok, %{message: "Validation failed"}}
    end
  end

  def get(_parent, %{id: id}, _resolution) do
    case CreditApplications.get_credit_application(id) do
      nil -> {:error, "Not found"}
      application -> {:ok, application}
    end
  end

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
