require 'devise_ad_authenticatable/strategy'

module Devise
  module Models
    # AD Module, responsible for validating the user credentials via Active Directory.
    #
    # Examples:
    #
    #    User.authenticate('email@test.com', 'password123')  # returns authenticated user or nil
    #    User.find(1).valid_password?('password123')         # returns true/false
    #
    module ADAuthenticatable
      extend ActiveSupport::Concern

      included do
        attr_reader :current_password, :password
        attr_accessor :password_confirmation
      end

      def login_with
        self[::Devise.authentication_keys.first]
      end

      # Checks if a resource is valid upon authentication.
      def valid_ad_authentication?(password)
        if Devise::ADAdapter.valid_credentials?(login_with, password)
          return true
        else
          return false
        end
      end

      module ClassMethods
        # Authenticate a user based on configured attribute keys. Returns the
        # authenticated user if it's valid or nil.
        def authenticate_with_ad(attributes={})
          debugger
          @login_with = ::Devise.authentication_keys.first
          return nil unless attributes[@login_with].present? 

          # resource = find_for_ad_authentication(conditions)
          resource = scoped.where(@login_with => attributes[@login_with]).first
                    
          if (resource.blank? and ::Devise.ad_create_user)
            resource = new
            resource[@login_with] = attributes[@login_with]
            resource.password = attributes[:password]
          end
                    
          if resource.try(:valid_ad_authentication?, attributes[:password])
            resource.save if resource.new_record?
            return resource
          else
            return nil
          end
        end
        
        def update_with_password(resource)
          puts "UPDATE_WITH_PASSWORD: #{resource.inspect}"
        end
        
      end
    end
  end
end
