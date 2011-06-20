module DeviseAdAuthenticatable
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("../templates", __FILE__)
    
    class_option :user_model, :type => :string, :default => "user", :desc => "Model to update"
    class_option :update_model, :type => :boolean, :default => true, :desc => "Update model to change from database_authenticatable to ad_authenticatable"
    class_option :add_rescue, :type => :boolean, :default => true, :desc => "Update Application Controller with resuce_from for DeviseAdAuthenticatable::AdException"
    class_option :advanced, :type => :boolean, :desc => "Add advanced config options to the devise initializer"
    
    
    def create_ad_config
      copy_file "ad.yml", "config/ad.yml"
    end
    
    def create_default_devise_settings
      inject_into_file "config/initializers/devise.rb", default_devise_settings, :after => "Devise.setup do |config|\n"   
    end
    
    def update_user_model
      gsub_file "app/models/#{options.user_model}.rb", /:database_authenticatable/, ":ad_authenticatable" if options.update_model?
    end
    
    def update_application_controller
      inject_into_class "app/controllers/application_controller.rb", ApplicationController, rescue_from_exception if options.add_rescue?
    end
    
    private
    
    def default_devise_settings
      settings = <<-eof
  # ==> AD Configuration 
  # config.ad_logger = true
  # config.ad_create_user = false
  # config.ad_update_password = true
  # config.ad_config = "\#{Rails.root}/config/ad.yml"
  # config.ad_check_group_membership = false
  # config.ad_check_attributes = false
  # config.ad_use_admin_to_bind = false
  
      eof
      if options.advanced?  
        settings << <<-eof  
  # ==> Advanced AD Configuration
  # config.ad_auth_username_builder = Proc.new() {|attribute, login, ldap| "\#{attribute}=\#{login}" }
  
        eof
      end
      
      settings
    end
    
    def rescue_from_exception
      <<-eof
  rescue_from DeviseAdAuthenticatable::AdException do |exception|
    render :text => exception, :status => 500
  end
      eof
    end
    
  end
end
