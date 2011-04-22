# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def title
    base_title = "Link Networker Members Area"
    if @title.nil?
      base_title
    else
      "#{h(@title)} | #{base_title}"
    end
  end
  
  def section
    if @user.contents.empty?
      "Keywords"
    else
      "Keywords & Content URLs"
    end
  end

end
