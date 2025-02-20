# frozen_string_literal: true

# Pin npm packages by running ./bin/importmap

pin 'application'
pin '@hotwired/turbo-rails', to: 'turbo.min.js'
pin '@hotwired/stimulus', to: 'stimulus.min.js'
pin '@hotwired/stimulus-loading', to: 'stimulus-loading.js'
pin_all_from 'app/javascript/controllers', under: 'controllers'
pin 'el-transition', to: "https://cdn.jsdelivr.net/npm/el-transition@0.0.7/index.js" # @0.0.7
pin 'flatpickr', to: "https://ga.jspm.io/npm:flatpickr@4.6.13/dist/esm/index.js"
pin 'stimulus-flatpickr', to: 'https://ga.jspm.io/npm:stimulus-flatpickr@3.0.0-0/dist/index.m.js'
pin "aos", to:"https://ga.jspm.io/npm:aos@2.3.4/dist/aos.js" #@2.3.4
pin "@stimulus-components/dialog", to: "@stimulus-components--dialog.js" # @1.0.1
