require File.dirname(__FILE__) + '/../test_helper'
require 'dramasoc_controller'

# Re-raise errors caught by the controller.
class DramasocController; def rescue_action(e) raise e end; end

class DramasocControllerTest < Test::Unit::TestCase
  def setup
    @controller = DramasocController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
