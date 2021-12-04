class Players::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token
  respond_to :json

  private

  def respond_with(resource, _opts = {})
    render json: { message: 'Logged in' }, status: :ok
  end

  def respond_to_on_destroy
    log_out_success && return if current_player

    log_out_failure
  end

  def log_out_success
    render json: { message: 'Logged out' }, status: :ok
  end

  def log_out_failure
    render json: { message: 'Nothing happened' }, status: :unauthorized
  end
end
