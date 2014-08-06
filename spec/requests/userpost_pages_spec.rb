require 'spec_helper'

describe "Userpost pages" do

  #This will be a test for posting on a game page.
  #Plan to update home page to quick post to any game the user is attached to.

  subject {page}
  let(:user) {FactoryGirl.create(:user)}
  let(:game) {FactoryGirl.create(:game)}


  before(:all) do
    sign_in user
  end

  describe "userpost to game" do
    let(:user) {FactoryGirl.create(:user)}
    let(:game) {FactoryGirl.create(:game)}
    let(:event_vote) {FactoryGirl.create(:event_vote)}


    before{visit game_path(game)}

    describe "with invalid content" do

      it "should not create userpost" do
        expect {click_button "Post"}.not_to change(Userpost, :count)
      end

          describe "error messages" do
            before { click_button "Post" }
            it { should have_content('error') }
          end

        describe "with valid information" do

          before { fill_in 'userpost_content', with: "Lorem ipsum" }
          it "should create a userpost" do
            expect { click_button "Post" }.to change(Userpost, :count).by(1)
          end
        end
      end

    end
  end

  # subject { page }
  #
  # let(:user) { FactoryGirl.create(:user) }
  # before { sign_in user }
  #
  # describe "userpost creation" do
  #   before { visit root_path }
  #
  #   describe "with invalid information" do
  #
  #     it "should not create a userpost" do
  #       expect { click_button "Post" }.not_to change(Userpost, :count)
  #     end
  #
  #     describe "error messages" do
  #       before { click_button "Post" }
  #       it { should have_content('error') }
  #     end
  #   end
  #
  #   describe "with valid information" do
  #
  #     before { fill_in 'userpost_content', with: "Lorem ipsum" }
  #     it "should create a userpost" do
  #       expect { click_button "Post" }.to change(Userpost, :count).by(1)
  #     end
  #   end
  # end