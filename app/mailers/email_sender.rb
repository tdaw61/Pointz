class EmailSender < ActionMailer::Base

  default from: "tdaw6134@yahoo.com"

    def join_league(user, league, current_user)
      @user = user
      @url  = 'http://0.0.0.0:3000/'
      subject = current_user.name + " invites you to join " + league.name
      mail(to: 'tdaw6134@yahoo.com', subject: subject).deliver
    end

    def welcome(user)
      @user = user
      mail(to: 'tdaw6134@yahoo.com', subject: 'Welcome to ManPoints').deliver
    end
end
