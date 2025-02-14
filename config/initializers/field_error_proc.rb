# frozen_string_literal: true

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  # Return the original HTML tag without any wrapping
  html_tag.html_safe
end
