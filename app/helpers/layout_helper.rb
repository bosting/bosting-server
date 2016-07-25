module LayoutHelper
  def flash_messages
    flash_messages = []
    flash.each do |type, message|
      type = type.to_sym
      type = :success if type == :notice
      type = :danger  if type == :alert
      type = :danger  if type == :error
      next unless [:success, :info, :warning, :danger].include?(type)

      close_button = content_tag(:button, type: 'button', class: 'close', 'data-dismiss' => 'alert', 'aria-label' => 'Close') do
        content_tag(:span, raw('&times;'), 'aria-hidden' => 'true')
      end

      Array(message).each do |msg|
        text = content_tag(:div, close_button + msg, class: "alert alert-#{type} alert-dismissible", role: 'alert')
        flash_messages << text if msg
      end
    end
    flash_messages.join("\n").html_safe
  end

  def admin_icon(action)
    case action
      when :edit
        glyphicon_bs('edit')
      when :destroy
        glyphicon_fa('trash')
    end
  end

  def link_to_edit(path)
    link_to(admin_icon(:edit), [:edit, path].flatten, class: 'btn btn-sm btn-primary')
  end

  def link_to_destroy(path)
    link_to(admin_icon(:destroy), path, data: { confirm: t('site.confirm') }, method: :delete, class: 'btn btn-sm btn-danger pull-right')
  end

  def options_for_horizontal_form
    {
        html: {
            class: 'form-horizontal'
        },
        wrapper: :horizontal_form,
        wrapper_mappings: {
            check_boxes: :horizontal_radio_and_checkboxes,
            radio_buttons: :horizontal_radio_and_checkboxes,
            file: :horizontal_file_input,
            boolean: :horizontal_boolean
        }
    }
  end
end
