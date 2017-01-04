module ApplicationHelper
  def flash_class(level)
    case level
      when 'notice' then "alert alert-info alert-dismissable fade in"
      when 'success' then "alert alert-success alert-dismissable fade in"
      when 'error' then "alert alert-danger alert-dismissable fade in"
      when 'alert' then "alert alert-warning alert-dismissable fade in"
    end
  end
end
