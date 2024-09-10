class ApplicationController < ActionController::Base
    before_action :authenticate_user!
    before_action :configure_permitted_parameters, if: :devise_controller?
    include Pundit
    rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

    def success_response(status, message, data = nil)
        render json: {
          status: status,
          message: message,
          data: data
        }, status: status
    end
    
    def error_response(status, message, errors = nil)
        render json: {
            status: status,
            message: message,
            errors: errors
        }, status: status
    end

    protected
  
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone_number, :role])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name, :phone_number, :role])
    end

    private

    def user_not_authorized
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to root_path
    end

end
