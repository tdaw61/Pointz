class SandboxEmailInterceptor
  def self.delivering_email(message)
    message.to = ['tdaw61@gmail.com']
  end
end