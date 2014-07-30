require 'spec_helper'

describe Game do

  before do
    @game = Game.new(name: "Test User", motto: "Super Test")
  end

  subject { @game}

  it { should respond_to(:name)}
  it { should respond_to(:motto) }
  it { should respond_to(:start_date) }
  it { should respond_to(:end_date) }

  it { should be_valid }

  describe "when name is not present" do
    before { @game.name = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @game.name = "x" * 31 }
    it { should_not be_valid }
  end

  # describe "gameEvent associations" do
  #
  #   before { @user.save }
  #   let!(:older_userpost) do
  #     FactoryGirl.create(:userpost, user: @user, created_at: 1.day.ago)
  #   end
  #   let!(:newer_userpost) do
  #     FactoryGirl.create(:userpost, user: @user, created_at: 1.hour.ago)
  #   end
  #
  #   it "should have the right userposts in the right order" do
  #     expect(@user.userposts.to_a).to eq [newer_userpost, older_userpost]
  #   end
  #
  #   it "should destroy associated userposts" do
  #     userposts = @user.userposts.to_a
  #     @user.destroy
  #     expect(userposts).not_to be_empty
  #     userposts.each do |userpost|
  #       expect(Userpost.where(id: userpost.id)).to be_empty
  #     end
  #   end
  # end

end
