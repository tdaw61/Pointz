require 'spec_helper'

describe League do

  before do
    @league = build(:league)
  end

  subject {@league}

  it {is_expected.to be_valid}

  it "responds to photo" do
    is_expected.to respond_to(:photo)
  end

  it "is valid with a name" do
    expect(@league).to be_valid
  end

  it "is invalid without a name" do
    @league.name = nil
    @league.valid?
    expect(@league.errors[:name]).to include("can't be blank")
  end

end
