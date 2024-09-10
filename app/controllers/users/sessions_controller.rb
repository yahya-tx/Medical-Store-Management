# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end


  # POST /resource/sign_in
  def create
    email = params[:user][:email]
    password = params[:user][:password]
    phone_number = params[:user][:phone_number]
    role = params[:user][:role]
    
    user = User.find_by(email: email)
    
    if user && user.valid_password?(password)
      if user.role == role
        sign_in_and_redirect user, event: :authentication
      else
        flash[:alert] = "Invalid phone number or role."
        redirect_to new_user_session_path
      end
    else
      flash[:alert] = "Invalid email or password."
      redirect_to new_user_session_path
    end
  end


  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
