module ApplicationHelper
  def flash_class(klass)
    case klass
      when :notice then ''
      when :alert then 'warning'
      when :error then 'danger'
      when :success then 'success'
    end
  end
  
  def button_as_link(target, options = nil, &block)
    options ||= {}
    options = options.stringify_keys
    options[:onclick] = "javascript: window.location.href = '#{target}'"
    options[:class] ||= "uk-button"
    
    options.reverse_merge! 'name' => 'button', 'type' => 'button'
    content_tag 'Button', options, &block
  end
end
