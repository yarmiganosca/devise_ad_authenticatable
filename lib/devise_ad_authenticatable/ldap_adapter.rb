require "net/ldap"

module Devise

  module ADAdapter
    
    def self.valid_credentials?(login, password_plaintext)
      options = {:login => login, 
                 :password => password_plaintext, 
                 :ad_auth_username_builder => ::Devise.ad_auth_username_builder,
                 :admin => ::Devise.ad_use_admin_to_bind}
                 
      resource = ADConnect.new(options)
      resource.authorized?
    end

    class ADConnect

      attr_reader :ad, :login

      def initialize(params = {})
        ad_config = YAML.load(ERB.new(File.read(::Devise.ad_config || "#{Rails.root}/config/ad.yml")).result)[Rails.env]

        ad_options = params
        ad_options[:encryption] = :simple_tls if ad_config["ssl"]
        ['host','port','base'].each do |ad_param|
          ad_options[ad_param.to_sym] = ad_config[ad_param]
        end

        @ad = Net::LDAP.new(ad_options)

        @ad.auth ldap_config['admin_user'], ldap_config['admin_password'] if params[:admin]

        @attribute = ad_config["attribute"]
        @ad_auth_username_builder = params[:ad_auth_username_builder]
                
        @login = params[:login]
        @password = params[:password]
      end

      def dn
        DeviseADAuthenticatable::Logger.send("AD search: #{@attribute}=#{@login}")
        filter = Net::LDAP::Filter.eq(@attribute.to_s, @login.to_s)
        ad_entry = nil
        @ad.search(:filter => filter) {|entry| ad_entry = entry}
        if ad_entry.nil?
          @ad_auth_username_builder.call(@attribute,@login,@ad)
        else
          ad_entry.dn
        end
      end

      def authenticate!
        @ad.auth(@login, @password)
        @ad.bind
      end

      def authenticated?
        @ad.bind || authenticate!
      end

      def authorized?
        DeviseADAuthenticatable::Logger.send("Authorizing user #{@login}")
        authenticated?
      end

      def find_ad_user(ad)
        DeviseADAuthenticatable::Logger.send("Finding user: #{dn}")
        ad.search(:base => dn, :scope => Net::LDAP::SearchScope_BaseObject).try(:first)
      end

    end

  end

end
