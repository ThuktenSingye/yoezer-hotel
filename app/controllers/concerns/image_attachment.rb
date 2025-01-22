# frozen_string_literal: true

# Provides methods to validate and attach images to ActiveRecord models.
module ImageAttachment
  extend ActiveSupport::Concern

  class_methods do
    def attach_image(record, params, params_key)
      return unless valid_image?(params[params_key])

      record.send(params_key).attach(params[params_key])
    end

    private

    def valid_image?(image)
      image.present? && image.is_a?(ActionDispatch::Http::UploadedFile)
    end
  end
end
