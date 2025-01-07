const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}'
  ],
  theme: {
    extend: {
      colors: {
        primary: '#7C6A46',
        'background': '#F4F7FC',
        'success': '#34D03B',
        'error': '#FF543E',
        'rating': '#FFCE31',
        'white': '#FFFFFF',
        'text-color': '#1C1C1C'
      },
      fontFamily: {
        'playfair': [`"Playfair Display"`, ...defaultTheme.fontFamily.sans],
        'poppins': ['Poppins', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    // require('@tailwindcss/forms'),
    // require('@tailwindcss/typography'),
    // require('@tailwindcss/container-queries'),
  ]
}
