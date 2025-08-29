import RiskAssessment from "./hooks/risk-assessment"
import FinancialInfo from "./hooks/financial-info"

let Hooks = {
  RiskAssessment,
  FinancialInfo
}

let liveSocket = new LiveSocket("/live", Socket, {
  params: {_csrf_token: csrfToken},
  hooks: Hooks
})