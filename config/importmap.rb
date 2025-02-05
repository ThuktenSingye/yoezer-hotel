# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application'
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin 'el-transition' # @0.0.7
pin 'flatpickr' # @4.6.13
pin 'stimulus-flatpickr' # @3.0.0
pin "swiper" # @11.2.2

# pin "swiper", to: "https://ga.jspm.io/npm:swiper@11.0.5/swiper.esm.js"