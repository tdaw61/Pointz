FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Person #{n}" }
    sequence(:email) { |n| "person_#{n}@example.com" }
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :userpost do
    data "Lorem ipsum"
    user
  end

  factory :game do
    name "RSpec game"
  end

  factory :score do
    game
    user
  end

  factory :game_event do

  end

  factory :event_vote do
    points 1
    game
    user
    game_event
  end

end