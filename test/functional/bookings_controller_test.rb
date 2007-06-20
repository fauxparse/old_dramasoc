require File.dirname(__FILE__) + '/../test_helper'
require 'bookings_controller'

# Re-raise errors caught by the controller.
class BookingsController; def rescue_action(e) raise e end; end

class BookingsControllerTest < Test::Unit::TestCase
  def setup
    @controller = BookingsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
