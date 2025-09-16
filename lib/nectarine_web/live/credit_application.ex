defmodule NectarineWeb.CreditApplicationLive do
  use NectarineWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok,
     assign(socket,
       step: 1,
       form_data: %{},
       risk_score: 0,
       application_result: nil,
       errors: []
     )}
  end

  def handle_event("risk-assessment-submit", %{"risk_assessment" => data}, socket) do
    score = calculate_risk_score(data)

    if score > 6 do
      {:noreply,
       assign(socket,
         step: 2,
         form_data: Map.put(socket.assigns.form_data, "risk_assessment", data),
         risk_score: score,
         errors: []
       )}
    else
      {:noreply,
       assign(socket,
         step: "rejected",
         risk_score: score,
         errors: []
       )}
    end
  end

  def handle_event("financial-info-submit", %{"financial_info" => data}, socket) do
    # Flatten the nested data structure to match the schema
    risk_data = Map.get(socket.assigns.form_data, "risk_assessment", %{})
    all_data = Map.merge(risk_data, data)

    case create_application_via_graphql(all_data) do
      {:ok, %{message: message}} ->
        {:noreply, assign(socket, errors: [message])}

      {:ok, result} ->
        {:noreply,
         assign(socket,
           step: 3,
           application_result: result,
           errors: []
         )}
    end
  end

  def handle_event("back-to-step-1", _params, socket) do
    {:noreply, assign(socket, step: 1, form_data: %{}, risk_score: 0, errors: [])}
  end

  defp calculate_risk_score(data) do
    if(data["has_job"], do: 4, else: 0) +
      if(data["job_12_months"], do: 2, else: 0) +
      if(data["owns_home"], do: 2, else: 0) +
      if(data["owns_car"], do: 1, else: 0) +
      if data["additional_income"], do: 2, else: 0
  end

  defp create_application_via_graphql(data) do
    # Call your GraphQL resolver directly
    NectarineWeb.Graphql.Resolvers.CreditApplication.create(nil, %{input: data}, nil)
  end

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-gradient-to-br from-blue-50 via-indigo-50 to-purple-50 py-8">
      <div class="max-w-4xl mx-auto px-6">
        <div class="bg-white rounded-2xl shadow-2xl p-8 border border-gray-100">
          <div class="text-center mb-8">
            <h1 class="text-4xl font-bold text-gray-800 mb-2">
              Nectarine Credit Approval
            </h1>
            <p class="text-gray-600">Fast, secure, and transparent credit assessment</p>
          </div>
          
          <%= if length(@errors) > 0 do %>
            <div class="bg-red-50 border border-red-200 text-red-700 px-6 py-4 rounded-xl mb-8">
              <div class="flex items-center">
                <svg class="w-5 h-5 mr-2" fill="currentColor" viewBox="0 0 20 20">
                  <path fill-rule="evenodd" d="M18 10a8 8 0 11-16 0 8 8 0 0116 0zm-7 4a1 1 0 11-2 0 1 1 0 012 0zm-1-9a1 1 0 00-1 1v4a1 1 0 102 0V6a1 1 0 00-1-1z" clip-rule="evenodd"></path>
                </svg>
                <span class="font-medium">Please correct the following errors:</span>
              </div>
              <ul class="list-disc list-inside mt-2 ml-4">
                <%= for error <- @errors do %>
                  <li><%= error %></li>
                <% end %>
              </ul>
            </div>
          <% end %>
          
          <%= case @step do %>
            <% 1 -> %>
              <div class="risk-assessment-step">
                <div class="text-center mb-8">
                  <h2 class="text-3xl font-semibold text-gray-800 mb-3">Risk Assessment</h2>
                  <p class="text-gray-600 text-lg">Please answer the following questions to assess your credit risk. Each answer contributes to your overall risk score.</p>
                </div>
                
                <form phx-submit="risk-assessment-submit" class="space-y-6">
                  <div class="space-y-4">
                    <div class="flex items-center justify-between p-6 border-2 border-gray-200 rounded-xl hover:border-blue-300 transition-all duration-200 bg-gray-50 hover:bg-blue-50">
                      <div class="flex-1">
                        <label class="text-xl font-semibold text-gray-800">Do you have a paying job?</label>
                        <p class="text-blue-600 font-medium">4 points</p>
                      </div>
                      <input type="checkbox" 
                             name="risk_assessment[has_job]" 
                             value="true"
                             class="w-6 h-6 text-blue-600 rounded border-gray-300 focus:ring-blue-500">
                    </div>
                    
                    <div class="flex items-center justify-between p-6 border-2 border-gray-200 rounded-xl hover:border-blue-300 transition-all duration-200 bg-gray-50 hover:bg-blue-50">
                      <div class="flex-1">
                        <label class="text-xl font-semibold text-gray-800">Have you consistently had a paying job for the past 12 months?</label>
                        <p class="text-blue-600 font-medium">2 points</p>
                      </div>
                      <input type="checkbox" 
                             name="risk_assessment[job_12_months]" 
                             value="true"
                             class="w-6 h-6 text-blue-600 rounded border-gray-300 focus:ring-blue-500">
                    </div>
                    
                    <div class="flex items-center justify-between p-6 border-2 border-gray-200 rounded-xl hover:border-blue-300 transition-all duration-200 bg-gray-50 hover:bg-blue-50">
                      <div class="flex-1">
                        <label class="text-xl font-semibold text-gray-800">Do you own a home?</label>
                        <p class="text-blue-600 font-medium">2 points</p>
                      </div>
                      <input type="checkbox" 
                             name="risk_assessment[owns_home]" 
                             value="true"
                             class="w-6 h-6 text-blue-600 rounded border-gray-300 focus:ring-blue-500">
                    </div>
                    
                    <div class="flex items-center justify-between p-6 border-2 border-gray-200 rounded-xl hover:border-blue-300 transition-all duration-200 bg-gray-50 hover:bg-blue-50">
                      <div class="flex-1">
                        <label class="text-xl font-semibold text-gray-800">Do you own a car?</label>
                        <p class="text-blue-600 font-medium">1 point</p>
                      </div>
                      <input type="checkbox" 
                             name="risk_assessment[owns_car]" 
                             value="true"
                             class="w-6 h-6 text-blue-600 rounded border-gray-300 focus:ring-blue-500">
                    </div>
                    
                    <div class="flex items-center justify-between p-6 border-2 border-gray-200 rounded-xl hover:border-blue-300 transition-all duration-200 bg-gray-50 hover:bg-blue-50">
                      <div class="flex-1">
                        <label class="text-xl font-semibold text-gray-800">Do you have any additional source of income?</label>
                        <p class="text-blue-600 font-medium">2 points</p>
                      </div>
                      <input type="checkbox" 
                             name="risk_assessment[additional_income]" 
                             value="true"
                             class="w-6 h-6 text-blue-600 rounded border-gray-300 focus:ring-blue-500">
                    </div>
                  </div>
                  
                  <button type="submit" class="w-full bg-gradient-to-r from-blue-600 to-indigo-600 text-white py-4 px-8 rounded-xl text-xl font-semibold hover:from-blue-700 hover:to-indigo-700 transform hover:scale-105 transition-all duration-200 shadow-lg">
                    Continue to Financial Information
                  </button>
                </form>
              </div>
              
            <% 2 -> %>
              <div class="financial-info-step">
                <div class="text-center mb-8">
                  <h2 class="text-3xl font-semibold text-gray-800 mb-3">Financial Information</h2>
                  <div class="inline-flex items-center px-4 py-2 bg-green-100 text-green-800 rounded-full text-lg font-medium">
                    <svg class="w-5 h-5 mr-2" fill="currentColor" viewBox="0 0 20 20">
                      <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path>
                    </svg>
                    Your risk score: <span class="font-bold text-green-700 ml-1"><%= @risk_score %></span>
                  </div>
                  <p class="text-gray-600 text-lg mt-3">Please provide your financial details to complete your application.</p>
                </div>
                
                <form phx-submit="financial-info-submit" class="space-y-8">
                  <div class="space-y-6">
                    <div class="bg-gradient-to-r from-blue-50 to-indigo-50 p-6 rounded-xl border border-blue-200">
                      <label class="block text-xl font-semibold text-gray-800 mb-3">
                        What is your total monthly income from all income sources? (USD)
                      </label>
                      <input type="number" 
                             name="financial_info[monthly_income]" 
                             step="0.01" 
                             min="0"
                             required
                             placeholder="Enter your monthly income"
                             class="w-full p-4 border-2 border-blue-200 rounded-lg focus:ring-2 focus:ring-blue-500 focus:border-blue-500 text-lg">
                    </div>
                    
                    <div class="bg-gradient-to-r from-purple-50 to-pink-50 p-6 rounded-xl border border-purple-200">
                      <label class="block text-xl font-semibold text-gray-800 mb-3">
                        What are your total monthly expenses? (USD)
                      </label>
                      <input type="number" 
                             name="financial_info[monthly_expenses]" 
                             step="0.01" 
                             min="0"
                             required
                             placeholder="Enter your monthly expenses"
                             class="w-full p-4 border-2 border-purple-200 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-purple-500 text-lg">
                    </div>
                    
                    <div class="bg-gradient-to-r from-green-50 to-emerald-50 p-6 rounded-xl border border-green-200">
                      <label class="block text-xl font-semibold text-gray-800 mb-3">
                        Email Address
                      </label>
                      <input type="email" 
                             name="financial_info[email]" 
                             required
                             placeholder="Enter your email address"
                             class="w-full p-4 border-2 border-green-200 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-green-500 text-lg">
                    </div>
                  </div>
                  
                  <div class="flex space-x-4">
                    <button type="button" 
                            phx-click="back-to-step-1"
                            class="flex-1 bg-gray-500 text-white py-4 px-8 rounded-xl text-xl font-semibold hover:bg-gray-600 transition-colors shadow-lg">
                      ← Back
                    </button>
                    <button type="submit" class="flex-1 bg-gradient-to-r from-green-600 to-emerald-600 text-white py-4 px-8 rounded-xl text-xl font-semibold hover:from-green-700 hover:to-emerald-700 transform hover:scale-105 transition-all duration-200 shadow-lg">
                      Submit Application
                    </button>
                  </div>
                </form>
              </div>
              
            <% 3 -> %>
              <div class="success-message text-center">
                <div class="text-green-500 text-8xl mb-6 animate-bounce">✓</div>
                <h2 class="text-3xl font-bold text-gray-800 mb-6">Application Complete!</h2>
                <%= if @application_result.approved_amount do %>
                  <div class="bg-gradient-to-r from-green-50 to-emerald-50 border-2 border-green-200 rounded-xl p-8 mb-8">
                    <p class="text-2xl text-green-700 font-bold mb-2">
                      🎉 Congratulations! 🎉
                    </p>
                    <p class="text-xl text-green-600">
                      You have been approved for credit up to <span class="font-bold text-2xl">$<%= @application_result.approved_amount %></span> (USD)
                    </p>
                  </div>
                <% end %>
                <div class="bg-blue-50 border-2 border-blue-200 rounded-xl p-6 mb-8">
                  <p class="text-lg text-blue-700">
                    A confirmation email with your application details has been sent to 
                    <span class="font-bold text-blue-800"><%= @application_result.email %></span>
                  </p>
                </div>
                <button phx-click="back-to-step-1" class="bg-gradient-to-r from-blue-600 to-indigo-600 text-white py-4 px-8 rounded-xl text-xl font-semibold hover:from-blue-700 hover:to-indigo-700 transform hover:scale-105 transition-all duration-200 shadow-lg">
                  Start New Application
                </button>
              </div>
              
            <% "rejected" -> %>
              <div class="rejection-message text-center">
                <div class="text-red-500 text-8xl mb-6 animate-pulse">✗</div>
                <h2 class="text-3xl font-bold text-gray-800 mb-6">Application Status</h2>
                <div class="bg-red-50 border-2 border-red-200 rounded-xl p-8 mb-8">
                  <p class="text-xl text-red-700 mb-4">
                    Thank you for your answers. We are currently unable to issue credit to you.
                  </p>
                  <div class="inline-flex items-center px-4 py-2 bg-red-100 text-red-800 rounded-full text-lg font-medium">
                    Your risk score: <span class="font-bold text-red-700 ml-1"><%= @risk_score %></span>
                  </div>
                </div>
                <p class="text-gray-600 mb-8 text-lg">
                  We recommend improving your financial situation and trying again in the future.
                </p>
                <button phx-click="back-to-step-1" class="bg-gradient-to-r from-blue-600 to-indigo-600 text-white py-4 px-8 rounded-xl text-xl font-semibold hover:from-blue-700 hover:to-indigo-700 transform hover:scale-105 transition-all duration-200 shadow-lg">
                  Try Again
                </button>
              </div>
          <% end %>
        </div>
      </div>
    </div>
    """
  end
end
