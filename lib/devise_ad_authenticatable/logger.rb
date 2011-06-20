module DeviseADAuthenticatable

  class Logger    
    def self.send(message, logger = Rails.logger)
      if ::Devise.ad_logger
        logger.add 0, "  \e[36mAD:\e[0m #{message}"
      end
    end
  end

end
