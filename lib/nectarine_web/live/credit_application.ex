defmodule NectarineWeb.CreditApplicationLive do
  use NectarineWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       step: 1,
       form_data: %{},
       risk_score: 0,
       application_result: nil
     )}
  end

  def handle_event("risk-assessment-complete", %{"data" => data}, socket) do
    score = calculate_risk_score(data)

    if score > 6 do
      {:noreply,
       assign(socket,
         step: 2,
         form_data: data,
         risk_score: score
       )}
    else
      {:noreply,
       assign(socket,
         step: "rejected",
         risk_score: score
       )}
    end
  end

  def handle_event("financial-info-complete", %{"data" => data}, socket) do
    # Create the credit application via GraphQL
    case create_application_via_graphql(Map.merge(socket.assigns.form_data, data)) do
      {:ok, %{message: message}} ->
        {:noreply, assign(socket, error: message)}
      {:ok, result} ->
        {:noreply,
         assign(socket,
           step: 3,
           application_result: result
         )}
    end
  end

  defp calculate_risk_score(data) do
    if(data["hasJob"], do: 4, else: 0) +
      if(data["job12Months"], do: 2, else: 0) +
      if(data["ownsHome"], do: 2, else: 0) +
      if(data["ownsCar"], do: 1, else: 0) +
      if data["additionalIncome"], do: 2, else: 0
  end

  defp create_application_via_graphql(data) do
    # Call your GraphQL resolver directly
    NectarineWeb.Graphql.Resolvers.CreditApplication.create(nil, %{input: data}, nil)
  end

  def render(assigns) do
    ~H"""
    <div class="credit-application-container">
      <h1>Nectarine Credit Approval</h1>
      
      <%= case @step do %>
        <% 1 -> %>
          <div id="risk-assessment-react" 
               phx-hook="RiskAssessment"
               data-step={@step}
               data-risk-score={@risk_score}>
            <!-- React component will be mounted here -->
          </div>
          
        <% 2 -> %>
          <div id="financial-info-react"
               phx-hook="FinancialInfo"
               data-step={@step}
               data-form-data={Jason.encode!(@form_data)}>
            <!-- React component will be mounted here -->
          </div>
          
        <% 3 -> %>
          <div class="success-message">
            <h2>Application Complete!</h2>
            <%= if @application_result.approved_amount do %>
              <p>Congratulations, you have been approved for credit up to $<%= @application_result.approved_amount %> (USD)</p>
            <% end %>
            <p>A confirmation email has been sent to <%= @application_result.email %></p>
          </div>
          
        <% "rejected" -> %>
          <div class="rejection-message">
            <h2>Application Status</h2>
            <p>Thank you for your answer. We are currently unable to issue credit to you.</p>
            <p>Your risk score: <%= @risk_score %></p>
          </div>
      <% end %>
    </div>
    """
  end
end
