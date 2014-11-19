namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_users
    # make_userposts
  end
end

def make_users
  admin = User.create!(name:     "Test User",
                       email:    "tester@test.com",
                       password: "foobar",
                       password_confirmation: "foobar",
                       admin: true,
                       super_user: false )
  30.times do |n|
    name  = Faker::Name.name
    email = "test-#{n+1}@test.com"
    password  = "password"
    User.create!(name:     name,
                 email:    email,
                 password: password,
                 password_confirmation: password)
  end
end

def make_userposts
  users = User.all.limit(6)
  20.times do
    data = Faker::Lorem.sentence(5)
    users.each { |user| user.userposts.create!(data: data) }
  end
end
