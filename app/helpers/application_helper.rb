module ApplicationHelper
  def flash_class(klass)
    case klass
      when :notice then ''
      when :alert then 'warning'
      when :error then 'danger'
      when :success then 'success'
    end
  end
end
