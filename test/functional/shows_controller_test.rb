require File.dirname(__FILE__) + '/../test_helper'
require 'shows_controller'

# Re-raise errors caught by the controller.
class ShowsController; def rescue_action(e) raise e end; end

class ShowsControllerTest < Test::Unit::TestCase
  def setup
    @controller = ShowsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
