require File.expand_path('../../test_helper', __FILE__)

class DevicesControllerTest < Redmine::IntegrationTest

  self.fixture_path = File.join(File.dirname(__FILE__), '../fixtures')
  fixtures :users, :devices, :loans

  # Replace this with your real tests.
  def test_if_controller_gets_proper_values
    log_user('admin', 'admin')
    get devices_statistics_path
    assert_response :success
    assert_equal assigns(:devices)[0][:count], Device.first.loans.count
    assert_equal assigns(:devices)[0][:top], User.find(2)
    assert_equal assigns(:devices)[0][:top_count], 4
  end

  def test_if_controller_denies_access_for_unlogged_user
    get devices_statistics_path
    assert_response :redirect
  end
end
