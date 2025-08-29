defmodule Nectarine.Email do
  import Swoosh.Email
  alias Nectarine.PDFGenerator

  def approval_email(application) do
    pdf_content = PDFGenerator.generate_application_pdf(application)

    new()
    |> to(application.email)
    |> from("noreply@nectarine.com")
    |> subject("Credit Approval - Congratulations!")
    |> text_body("Your credit application has been approved!")
    |> attachment(%Swoosh.Attachment{
      filename: "credit_application.pdf",
      content_type: "application/pdf",
      data: pdf_content
    })
  end
end
