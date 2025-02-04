# frozen_string_literal: true

# Provides methods to validate and attach images to ActiveRecord models.
module ImageAttachment
  extend ActiveSupport::Concern

  class_methods do
    def attach_image(record, params, params_key)
      return unless valid_image?(params[params_key])

      record.send(params_key).attach(params[params_key])
    end

    def attach_multiple_images(record, params, params_key)
      return unless valid_images?(params[params_key])

      params[params_key].each do |image|
        record.send(params_key).attach(image)
      end
    end

    private

    def valid_image?(image)
      image.present? && image.is_a?(ActionDispatch::Http::UploadedFile)
    end

    def valid_images?(images)
      images.is_a?(Array) && images.all? { |image| valid_image?(image) }
    end
  end
end
