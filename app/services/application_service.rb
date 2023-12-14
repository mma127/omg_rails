class ApplicationService

  private

  def error_logger(msg)
    Rails.logger.error("[#{self.class.name}] #{msg}")
  end

  def warn_logger(msg)
    Rails.logger.warn("[#{self.class.name}] #{msg}")
  end

  def info_logger(msg)
    Rails.logger.info("[#{self.class.name}] #{msg}")
  end
end
