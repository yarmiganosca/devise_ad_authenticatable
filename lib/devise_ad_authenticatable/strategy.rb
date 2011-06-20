require 'devise/strategies/authenticatable'

module Devise
  module Strategies
    # Strategy for signing in a user based on his login and password using AD.
    # Redirects to sign_in page if it's not authenticated
    class AdAuthenticatable < Authenticatable
      def valid?
        valid_controller? && valid_params?
      end

      # Authenticate a user based on login and password params, returning to warden
      # success and the authenticated user if everything is okay. Otherwise redirect
      # to sign in page.
      def authenticate!
        debugger
        login_with = params[scope][Devise.authentication_keys.first]
        password = params[scope][:password]
        if Devise::AdAdapter.valid_credentials(login_with, password)
          success!(resource)
        else
          fail(:invalid)
        end
      end

      protected

        def valid_controller?
          params[:controller] == 'devise/sessions'
        end

        def valid_params?
          params[scope] && params[scope][:password].present?
        end
    end
  end
end
debugger
Warden::Strategies.add(:ad_authenticatable, Devise::Strategies::AdAuthenticatable)
