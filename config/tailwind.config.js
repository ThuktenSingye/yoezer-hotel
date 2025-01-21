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
        primary: {
          'regular': '#7C6A46',
          'dark': '#755B26'
        },
        'background': '#F4F7FC',
        secondary: '#3B3486',
        'success': '#34D03B',
        'error': '#FF543E',
        'rating': '#FFCE31',
        'white': '#FFFFFF',
        'text-color': '#1C1C1C'
      },
      fontFamily: {
        'title': [`"Playfair Display"`, ...defaultTheme.fontFamily.sans],
        'poppins': ['Poppins', ...defaultTheme.fontFamily.sans],
        'body': [`"Libre Baskerville"`, ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    // require('@tailwindcss/forms'),
    // require('@tailwindcss/typography'),
    // require('@tailwindcss/container-queries'),
  ]
}
