module GlyphiconsHelper
  def glyphicon_bs(icon, title = nil)
    glyphicon_span_tag("glyphicon glyphicon-#{icon}", title)
  end

  def glyphicon_fa(icon, title = nil)
    glyphicon_span_tag("fa fa-#{icon}", title)
  end

  def glyphicon_fl(icon, title = nil)
    glyphicon_span_tag("fl-#{icon}", title)
  end

  def glyphicon_span_tag(klass, title)
    content_tag(:span, '', class: klass, title: title)
  end
end
