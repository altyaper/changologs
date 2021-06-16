module ApplicationHelper
  def icon(icon, options = {})
    file = File.read("node_modules/bootstrap-icons/icons/#{icon}.svg")
    doc = Nokogiri::HTML::DocumentFragment.parse file
    svg = doc.at_css 'svg'
    if options[:class].present?
      svg['class'] += " " + options[:class]
    end
      doc.to_html.html_safe
  end

  def flash_class(level)
    case level
      when :notice then "alert alert-info"
      when :success then "alert alert-success"
      when :error then "alert alert-danger"
      when :alert then "alert alert-warning"
    end
  end
end
