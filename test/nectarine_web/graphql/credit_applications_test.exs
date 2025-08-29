defmodule NectarineWeb.Graphql.CreditApplicationsTest do
  use NectarineWeb.ConnCase, async: false
  alias NectarineWeb.Graphql.Client

  setup do
    # Ensure the database is properly set up for this test
    Ecto.Adapters.SQL.Sandbox.checkout(Nectarine.Repo)

    # Return cleanup function
    on_exit(fn ->
      Ecto.Adapters.SQL.Sandbox.checkin(Nectarine.Repo)
    end)

    :ok
  end

  @create_application_mutation """
  mutation CreateCreditApplication($input: CreditApplicationInput!) {
    createCreditApplication(input: $input) {
      ... on CreditApplication {
        id
        riskScore
        status
        approvedAmount
        email
      }
      ... on Error {
        message
      }
    }
  }
  """

  describe "create credit application" do
    test "creates application with high risk score and approves credit", %{conn: conn} do
      input = %{
        "has_job" => true,
        "job_12_months" => true,
        "owns_home" => true,
        "owns_car" => true,
        "additional_income" => true,
        "monthly_income" => "5000.00",
        "monthly_expenses" => "2000.00",
        "email" => "tshepok13@gmail.com"
      }

      result = Client.query!(conn, @create_application_mutation, %{input: input})

      %{"createCreditApplication" => application} = result

      assert application["riskScore"] == 11
      assert application["status"] == "approved"
      assert application["approvedAmount"] == "36000.00"
      assert application["email"] == "tshepok13@gmail.com"
      
      # Add a small delay to allow email to be sent asynchronously
      Process.sleep(100)
    end

    test "rejects application with low risk score", %{conn: conn} do
      input = %{
        "has_job" => false,
        "job_12_months" => false,
        "owns_home" => false,
        "owns_car" => false,
        "additional_income" => false,
        "monthly_income" => "1000.00",
        "monthly_expenses" => "800.00",
        "email" => "tshepok13@gmail.com"
      }

      result = Client.query!(conn, @create_application_mutation, %{input: input})

      %{"createCreditApplication" => application} = result

      assert application["riskScore"] == 0
      assert application["status"] == "rejected"
      assert application["approvedAmount"] == nil
    end

    test "validates required fields", %{conn: conn} do
      input = %{
        "has_job" => true,
        "job_12_months" => true,
        "owns_home" => true,
        "owns_car" => true,
        "additional_income" => true
        # Missing optional fields like monthly_income, monthly_expenses, email
      }

      result = Client.query!(conn, @create_application_mutation, %{input: input})

      # This should succeed since all required fields are provided
      %{"createCreditApplication" => application} = result
      assert application["riskScore"] == 11
      assert application["status"] == "approved"
    end

    test "fails with missing required fields", %{conn: conn} do
      input = %{
        "has_job" => true
        # Missing other required fields
      }

      result = Client.query(conn, @create_application_mutation, %{input: input})

      case result do
        %{"errors" => [error]} ->
          assert error["message"] =~ "Argument \"input\" has invalid value"
        %{"data" => %{"createCreditApplication" => %{"message" => message}}} ->
          assert message =~ "Validation failed"
      end
    end
  end
end
