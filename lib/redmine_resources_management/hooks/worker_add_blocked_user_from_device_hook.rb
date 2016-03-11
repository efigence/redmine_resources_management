module RedmineResourcesManagment
  module Hooks
    class WorkerAddBlockedUserFromDevice < Redmine::Hook::ViewListener
      def add_block_user_from_devices( context={} )
        Device.where('loan_date < ?', DateTime.now).map(&:loans_name)
      end
    end
  end
end
