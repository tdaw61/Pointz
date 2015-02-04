require 'spec_helper'

describe Game do

  before do
    @game = build(:game)
  end

  subject {@game}

  it{is_expected.to have_many :scores}
  it{is_expected.to have_many :userposts}
  it{is_expected.to have_many :game_events}
  it{is_expected.to have_many :ordered_scores}
  it{is_expected.to have_many :active_game_events}

  it "factory is valid" do
    is_expected.to be_valid
  end

  it "belongs to a league" do
    is_expected.to belong_to(:league)
  end

  describe "when name is not present" do
    before { @game.name = " " }
    it { is_expected.to_not be_valid }
  end

  describe "when name is too long" do
    before { @game.name = "x" * 31 }
    it { is_expected.to_not be_valid }
  end

  describe "#leader" do
    before{
      @game.save
    }
    let!(:higher_score) do
      create(:score, game: @game, points: 4)
    end
    let!(:lower_score) do
      create(:score, game: @game, points: 2)
    end

    it "will return the highest score" do
       expect(@game.leader).to eq higher_score
    end

    it "will not break with empty scores" do
        game = create(:game)
        expect(game.leader).to eq nil
    end
  end

  describe "#points" do

    it "returns N/A for a user with no score" do
      game = create(:game_with_scores)
    end

    it "returns the points value for user" do

    end

  end

  describe "#position" do

    it "returns N/A for a nil user position" do

    end

    it "returns the correct user rank in a game" do

    end

  end

  describe "#active_event_votes" do
    it "returns a users active event votes in a game" do

    end

  end

  describe "#inactive_event_votes" do
    it "returns a users inactive event votes in a game" do

    end
  end

  describe "#is_passing?" do
    it "checks game to see if caps are satisfied to close game" do

    end
  end

  describe "#deactivate" do
    it "sets game to active:false and creates userpost to notify users" do

    end
  end


end
