require File.dirname(__FILE__) + '/../test_helper'
require 'venues_controller'

# Re-raise errors caught by the controller.
class VenuesController; def rescue_action(e) raise e end; end

class VenuesControllerTest < Test::Unit::TestCase
  def setup
    @controller = VenuesController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
