defmodule NectarineWeb.Graphql.Resolvers.CreditApplication do
  alias Nectarine.CreditApplications
  alias Nectarine.Mailer
  alias Nectarine.Email

  def create(_parent, %{input: params}, _resolution) do
    case CreditApplications.create_credit_application(params) do
      {:ok, application} ->
        # Always return the application, whether approved or rejected
        # Only send email for approved applications
        if application.status == "approved" do
          Task.async(fn -> send_approval_email(application) end)
        end

        {:ok, application}

      {:error, changeset} ->
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
    application
    |> Email.approval_email()
    |> Mailer.deliver_now()
  end
end
