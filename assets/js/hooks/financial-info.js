// assets/js/hooks/financial-info.js
const FinancialInfo = {
    mounted() {
      const container = this.el;
      const step = this.el.dataset.step;
      const formData = JSON.parse(this.el.dataset.formData);
      
      import('./components/FinancialInfo').then(({ default: FinancialInfoComponent }) => {
        const root = ReactDOM.createRoot(container);
        root.render(
          <FinancialInfoComponent 
            onComplete={(data) => {
              this.pushEvent("financial-info-complete", { data });
            }}
            step={step}
            initialData={formData}
          />
        );
      });
    }
  };
  
  export default FinancialInfo;