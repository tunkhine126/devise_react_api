class Api::V1::SessionsController < Api::V1::BaseController
  respond_to :json

  def create
    user = User.find_for_database_authentication(email: params[:user] && params[:user][:email])
    if invalid_password?(user)
      respond_with_error "Incorrect email or password", 401
    else
      sign_in(user)
      render json: { auth_token: user.authentication_token, user: user }, status: :created
    end
  end

  def destroy
    sign_out(@user)
    reset_session
  end

  private

  def invalid_password?(user)
    user.blank? || !user.valid_password?(params[:user][:password])
  end
end