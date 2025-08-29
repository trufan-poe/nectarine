# lib/nectarine/pdf_generator.ex
defmodule Nectarine.PDFGenerator do
  def generate_application_pdf(application) do
    html_content = """
    <html>
      <head><title>Credit Application</title></head>
      <body>
        <h1>Credit Application Summary</h1>
        <p><strong>Has Job:</strong> #{application.has_job}</p>
        <p><strong>Job 12 Months:</strong> #{application.job_12_months}</p>
        <p><strong>Owns Home:</strong> #{application.owns_home}</p>
        <p><strong>Owns Car:</strong> #{application.owns_car}</p>
        <p><strong>Additional Income:</strong> #{application.additional_income}</p>
        <p><strong>Risk Score:</strong> #{application.risk_score}</p>
        <p><strong>Monthly Income:</strong> $#{application.monthly_income}</p>
        <p><strong>Monthly Expenses:</strong> $#{application.monthly_expenses}</p>
        <p><strong>Approved Amount:</strong> $#{application.approved_amount}</p>
        <p><strong>Status:</strong> #{application.status}</p>
      </body>
    </html>
    """

    PdfGenerator.generate(html_content)
  end
end
