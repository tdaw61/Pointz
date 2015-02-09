require 'spec_helper'

describe User do

  before do
    @user = build :user
  end

  subject { @user }

  it { is_expected.to respond_to(:name)}
  it { is_expected.to respond_to(:email)}
  it { is_expected.to respond_to(:password_digest)}
  it { is_expected.to respond_to(:password)}
  it { is_expected.to respond_to(:password_confirmation)}
  it { is_expected.to respond_to(:remember_token)}
  it { is_expected.to respond_to(:authenticate)}
  it { is_expected.to respond_to(:admin)}
  it { is_expected.to respond_to(:friends)}
  it { is_expected.to respond_to(:friendships)}
  it { is_expected.to respond_to(:pending_friends)}
  it { is_expected.to respond_to(:requested_friends)}
  it { is_expected.to respond_to(:game_events)}
  it { is_expected.to respond_to(:scores)}
  it { is_expected.to respond_to(:event_votes)}
  it { is_expected.to respond_to(:userposts)}
  it { is_expected.to respond_to(:super_user)}
  it { is_expected.to respond_to(:picture)}

  it { is_expected.to be_valid }

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe "when super admin is set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:super_user)
    end
    it "should be a super user" do
      is_expected.to be_super_user
    end
  end

  describe "when name is not present" do
    before { @user.name = " " }
    it { is_expected.to_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { is_expected.to_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { is_expected.to_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).to_not be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { is_expected.to_not be_valid }
  end

  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com",
                       password: " ", password_confirmation: " ")
    end
    it { is_expected.to_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { is_expected.to_not be_valid }
  end

  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
      it "be invalid" do
        is_expected.not_to be_valid
      end
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { is_expected.to eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it "should not be false" do
         expect(@user).to_not eq user_for_invalid_password
      end
    end
  end

  describe "remember token" do
    before { @user.save }
    it { expect(@user.remember_token).to_not be_blank }
  end

  describe "userpost associations" do

    before { @user.save }
    let!(:older_userpost) do
      FactoryGirl.create(:userpost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_userpost) do
      FactoryGirl.create(:userpost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right userposts in the right order" do
      expect(@user.userposts.to_a).to eq [newer_userpost, older_userpost]
    end

    it "should destroy associated userposts" do
      userposts = @user.userposts.to_a
      @user.destroy
      expect(userposts).not_to be_empty
      userposts.each do |userpost|
        expect(Userpost.where(id: userpost.id)).to be_empty
      end
    end
  end

  describe "friends" do
    before{@user.save}

    it "user has one friend" do
      friend = create(:user)
      @user.friendships << create(:friendship, user: @user, status: "accepted")
      expect(@user.friends.count).to eq 1
    end
  end

  describe "pending friendships" do
     before{@user.save}

    it "user has one pending friendship" do
      pending_friend = create(:user)
      @user.friendships << create(:friendship, user: @user, status: "pending")

      expect(@user.pending_friends.count).to eq 1
    end
  end

  describe "requested friendships" do
    before{@user.save}

    it "user has one requested friendship" do
      requested_friend = create(:user)
      @user.friendships << create(:friendship, user: @user, status: "requested")

      expect(@user.requested_friends.count).to eq 1
    end
  end

  describe "#open_votes" do

    before{@user.save}

      let!(:open_event_vote) do
        @user.event_votes << build(:event_vote, {game_event_id: 1, user: @user, game_id: 1})
      end
      let!(:closed_passing_event_vote) do
        @user.event_votes << build(:passing_event_vote, {game_event_id: 2, user: @user, game_id: 1})
      end
      let!(:closed_failing_event_vote) do
        @user.event_votes << build(:passing_event_vote, {game_event_id: 3, user: @user, game_id: 1})
      end


    it "should have a count of one" do
      expect(@user.open_votes.count).to eq 1
    end
  end

end