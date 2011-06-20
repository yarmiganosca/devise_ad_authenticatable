# encoding: utf-8
require 'devise'

require 'devise_ad_authenticatable/exception'
require 'devise_ad_authenticatable/logger'
require 'devise_ad_authenticatable/schema'
require 'devise_ad_authenticatable/ldap_adapter'
require 'devise_ad_authenticatable/routes'

# Get ad information from config/ad.yml now
module Devise
  # Allow logging
  mattr_accessor :ad_logger
  @@ad_logger = true
  
  # Add valid users to database
  mattr_accessor :ad_create_user
  @@ad_create_user = false
  
  mattr_accessor :ad_config
  @@ad_config = "#{Rails.root}/config/ad.yml"
  
  mattr_accessor :ad_update_password
  @@ad_update_password = true
  
  mattr_accessor :ad_check_group_membership
  @@ad_check_group_membership = false
  
  mattr_accessor :ad_check_attributes
  @@ad_check_role_attribute = false
  
  mattr_accessor :ad_use_admin_to_bind
  @@ad_use_admin_to_bind = false
  
  mattr_accessor :ad_auth_username_builder
  @@ad_auth_username_builder = Proc.new() {|attribute, login, ldap| "#{attribute}=#{login}" }
end

# Add ad_authenticatable strategy to defaults.
#
Devise.add_module(:ad_authenticatable,
                  :route => :session, ## This will add the routes, rather than in the routes.rb
                  :strategy   => true,
                  :controller => :sessions,
                  :model  => 'devise_ad_authenticatable/model')
