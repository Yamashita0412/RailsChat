User.create!(name:  "Example User",
             email: "example@railschat.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true)

User.create!(name:  "Example User2",
             email: "example2@railschat.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin: true)

10.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railschat.org"
  password = "password"
  User.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password)
end