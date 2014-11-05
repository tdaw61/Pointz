class EmailSender < ActionMailer::Base

  default from: "tdaw61@gmail.com"

    def join_league(user)

      @user = user
      @url  = 'http://0.0.0.0:3000/'
      mail(to: 'tdaw6134@yahoo.com', subject: 'Welcome to ManPoints').deliver
    end

    def send_test
      mail(to: 'tdaw61@gmail.com', subject: 'Welcome to ManPoints')
    end
end
