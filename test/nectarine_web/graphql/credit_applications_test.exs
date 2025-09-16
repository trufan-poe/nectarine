defmodule NectarineWeb.Graphql.CreditApplicationsTest do
  use NectarineWeb.ConnCase, async: false
  
  alias NectarineWeb.Graphql.Client

  # Helper function to convert struct to input map
  defp struct_to_input(struct) do
    struct
    |> Map.from_struct()
    |> Map.delete(:__meta__)
    |> Map.delete(:id)
    |> Map.delete(:risk_score)
    |> Map.delete(:approved_amount)
    |> Map.delete(:status)
    |> Map.delete(:inserted_at)
    |> Map.delete(:updated_at)
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
      input =
        build(:credit_application,
          owns_car: true,
          additional_income: true,
          monthly_income: "5000.00",
          monthly_expenses: "2000.00",
          email: "tshepok13@gmail.com"
        )
        |> struct_to_input()

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
      input =
        build(:credit_application,
          has_job: false,
          job_12_months: false,
          owns_home: false,
          monthly_income: "1000.00",
          monthly_expenses: "800.00"
        )
        |> struct_to_input()

      result = Client.query!(conn, @create_application_mutation, %{input: input})

      %{"createCreditApplication" => application} = result

      assert application["riskScore"] == 0
      assert application["status"] == "rejected"
      assert application["approvedAmount"] == nil
    end

    test "validates required fields", %{conn: conn} do
      input =
        build(:credit_application,
          owns_car: true,
          additional_income: true,
          monthly_income: "3000.00",
          monthly_expenses: "1500.00"
        )
        |> struct_to_input()

      result = Client.query!(conn, @create_application_mutation, %{input: input})

      # This should succeed since all required fields are provided
      %{"createCreditApplication" => application} = result
      assert application["riskScore"] == 11
      assert application["status"] == "approved"
    end

    test "fails with missing required fields", %{conn: conn} do
      input = 
        build(:credit_application, has_job: true, job_12_months: nil)
        |> struct_to_input()

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
