# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(name:  "tobi",
             email: "test@test.com",
             password:              "password",
             password_confirmation: "password",
             admin: true)

10.times do |n|
  name  = Faker::Name.name
  email = "test-#{n+1}@test.com"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end

# Posts
users = User.order(:created_at).take(6)
50.times do
  title = Faker::Lorem.sentence(word_count: 1)
  content = Faker::Lorem.sentence(word_count: 300)
  users.each { |user| user.posts.create!(title: title, content: content) }
end