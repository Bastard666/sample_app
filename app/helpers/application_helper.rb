module ApplicationHelper
  # Return the logo of the home page
  def logo
    image_tag("logo.png", :alt => "Sample app", :class => "round")
  end

  # Return the full title of the page
  def full_title(page_title ="")
    base_title = "Ruby on Rails Tutorial Sample App"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end
end
