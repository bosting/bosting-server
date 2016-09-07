module FormHelper
  def form_wrapper(heading, panel_type = 'default', &block)
    content_tag(:div, class: "panel panel-#{panel_type}") do
      content_tag(:div, heading, class: 'panel-heading') +
          content_tag(:div, class: 'panel-body') do
            capture(&block)
          end
    end
  end
end
