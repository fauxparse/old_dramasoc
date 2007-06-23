# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem

  class AccessDenied < StandardError; end

  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_dramasoc_session_id'

  before_filter :login_from_cookie
  around_filter :catch_errors

protected
  def catch_errors
    begin
      yield

    rescue AccessDenied
      flash[:notice] = "You do not have access to that area."
      redirect_to home_url
    rescue ActiveRecord::RecordNotFound
      flash[:notice] = "Sorry, can't find that record."
      redirect_to home_url
    end
  end
end
