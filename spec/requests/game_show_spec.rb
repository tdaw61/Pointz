# Test for a game's homepage.

require 'spec/spec_helper'

describe "Game Home page" do


  subject{page}
  let(:game) do
    create(:game)
  end
  let(:user) do
    create(:user, name: "Foo Guy")
  end
  let(:user_two) do
    create(:user, name: "Taylor Daw")
  end

  before :all do
    sign_in :user
  end
end
