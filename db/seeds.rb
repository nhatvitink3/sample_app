User.create!(
  name: "Admin",
  email: "admin@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  birthday: Date.new(2004, 1, 1),
  gender: :male,
  admin: true,
  activated: true,
  activated_at: Time.zone.now
)

50.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "123456"
  birthday = Faker::Date.birthday(min_age: 18, max_age: 40)
  gender = %w[male female other].sample

  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    birthday: birthday,
    gender: gender,
    activated: true,
    activated_at: Time.zone.now
  )
end
