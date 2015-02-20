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

  factory :league do
    name "RSpec factory league"

    factory :league_with_game do
      after(:build) do |league, evaluator|
        league.games << build(:game, league: league)
      end
    end

    factory :league_with_votes do
      after(:build) do |league, evaluator|
        league.games << build(:game_with_votes, league: league)
      end
    end
  end

  factory :game do
    name "RSpec game"
    league

    factory :game_with_votes do
      after(:build) do |game, evaluator|
        user = build(:user)
        game.users << user
        game.scores << build(:score, user: user, game: game)
        game.game_events << build(:game_event_with_votes, game: game )
      end
    end

    factory :game_with_scores do
      after(:create) do |game, evaluator|
        game.users << create(:user)
        game.users << (user1 factory: :user)
        game.scores << create(:score, user, game: game, points: 5)
        game.scores << create(:score, user1, game: game, points: 5)
      end
    end
  end

  factory :score do
    game
    user
    points 1
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

  factory :friendship do
    user
    friend factory: :user
  end

end