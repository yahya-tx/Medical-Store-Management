class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    before_action :configure_permitted_parameters, if: :devise_controller?
    include Pundit
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    def after_sign_in_path_for(current_user)
      if current_user.sign_in_count == 1
        v1_guidelines_path 
      else
        v1_root_path
      end
    end

    protected
  
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone_number, :role])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :phone_number, :role])
    end

    private

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to v1_root_path
    end

end
