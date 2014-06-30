require 'spec_helper'

describe Userpost do

  let(:user) { FactoryGirl.create(:user) }
  before { @userpost = user.userposts.build(data: "Lorem ipsum") }

  subject { @userpost }

  it { should respond_to(:data) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  # it { should respond_to(:game_id)}
  its(:user) { should eq user }

  it { should be_valid }

  describe "when user_id is not present" do
    before { @userpost.user_id = nil }
    it { should_not be_valid }
  end
  describe "with blank data" do
    before { @userpost.data = " " }
    it { should_not be_valid }
  end

  describe "with data that is too long" do
    before { @userpost.data = "a" * 141 }
    it { should_not be_valid }
  end

end
