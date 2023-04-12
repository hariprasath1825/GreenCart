class Api::ApiController < ApplicationController

  protect_from_forgery with: :null_session
  before_action :doorkeeper_authorize!

  skip_before_action :verify_authenticity_token

  respond_to :json

  def current_user
    @current_user ||= User.find_by(id: doorkeeper_token[:resource_owner_id])
  end

end
