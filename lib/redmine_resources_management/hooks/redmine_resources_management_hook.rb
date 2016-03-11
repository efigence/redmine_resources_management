module RedmineResourcesManagment
  module Hooks
    class RedmineResourcesManagmentHook < Redmine::Hook::ViewListener
      render_on(:view_devices_which_exceed_completion_date, :partial => 'devices/devices')
    end
  end
end
