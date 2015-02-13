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
    league
  end

  factory :league do
    name "RSpec factory league"
  end

  factory :score do
    game
    user
  end

  factory :game_event do
    point_value 2
    target_user user
    game

  end

  factory :event_vote do
    user_point_value 2
    game
    user
    game_event
    has_voted false

     factory :passing_event_vote do
       vote true
       has_voted true
     end

     factory :failing_event_vote do
       vote false
       has_voted true
     end
  end

end