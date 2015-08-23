module ApplicationHelper
  def active_action?(name, action)
    'active' if controller.class.name.underscore == name && action_name == action
  end

  def get_current_path
    request.original_fullpath.force_encoding('UTF-8').split('?')[0] || ''
  end

  def get_current_url
    URI.join(root_url, URI.escape(get_current_path)).to_s
  end
end
