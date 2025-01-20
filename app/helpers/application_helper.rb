module ApplicationHelper
  include Pagy::Frontend

  def flash_class(flash_type)
    case flash_type.to_sym
    when :notice then "flash-notice"
    when :alert  then "flash-alert"
    else "flash-normal"
    end
  end
end
