module ApplicationHelper
  # Return the logo of the home page
  def logo
    image_tag("logo.png", :alt => "Example Application", :class => "round")
  end
end
