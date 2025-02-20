# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application'
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin 'el-transition', to: "https://cdn.jsdelivr.net/npm/el-transition@0.0.7/index.js" # @0.0.7
pin 'flatpickr'
pin 'stimulus-flatpickr'
pin "aos", to:"https://ga.jspm.io/npm:aos@2.3.4/dist/aos.js" #@2.3.4
pin "@stimulus-components/dialog", to: "https://ga.jspm.io/npm:@stimulus-components/dialog@1.0.1/dist/stimulus-dialog.mjs" # @1.0.1
