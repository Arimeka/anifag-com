module ApplicationHelper
  def active_action?(name, action)
    'active' if controller_name == name && action_name == action
  end
end
