defmodule Nectarine.Email do
  import Swoosh.Email
  alias Nectarine.PDFGenerator

  def approval_email(application) do
    case PDFGenerator.generate_application_pdf(application) do
      {:ok, pdf_bin} ->
        new()
        |> to(application.email)
        |> from("noreply@sixkube.com")
        |> subject("Credit Approval - Congratulations!")
        |> text_body("Your credit application has been approved!")
        |> attachment(%Swoosh.Attachment{
          filename: "credit_application.pdf",
          content_type: "application/pdf",
          data: pdf_bin
        })

      {:error, reason} ->
        # Log the error and still send the email without attachment
        require Logger
        Logger.error("Failed to generate PDF: #{inspect(reason)}")

        new()
        |> to(application.email)
        |> from("noreply@sixkube.com")
        |> subject("Credit Approval - Congratulations!")
        |> text_body(
          "Your credit application has been approved! (PDF attachment could not be generated)"
        )
    end
  end
end
