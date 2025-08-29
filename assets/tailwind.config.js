/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/**/*.heex",
    "../lib/**/*.ex"
  ],
  theme: {
    extend: {
      colors: {
        'nectarine': {
          50: '#fef7ee',
          100: '#fdedd6',
          200: '#fad7ac',
          300: '#f6ba77',
          400: '#f1933d',
          500: '#ed7514',
          600: '#de5a0a',
          700: '#b8440c',
          800: '#933612',
          900: '#762e14',
        }
      }
    },
  },
  plugins: [],
}
