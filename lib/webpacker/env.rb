class Webpacker::Env < Shakapacker::Env
  def inquire
    fallback_env_warning if config_path.exist? && !current
    current || Webpacker::DEFAULT_ENV.inquiry
  end

  private

    def fallback_env_warning
      logger.info "RAILS_ENV=#{Rails.env} environment is not defined in config/webpacker.yml, falling back to #{Webpacker::DEFAULT_ENV} environment"
    end
end
