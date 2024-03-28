# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "seedの実行を開始"

Admin.create!(
   email: 'admin@admin',
   password: 'testtest'
)

userA = User.find_or_create_by!(email: "usera@example.com") do |user|
  user.name = "userA"
  user.password = "password"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/userA.jpg"), filename:"userA.jpg")
end

userB = User.find_or_create_by!(email: "userb@example.com") do |user|
  user.name = "userB"
  user.password = "password"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/userB.jpg"), filename:"userB.jpg")
end

userC = User.find_or_create_by!(email: "userc@example.com") do |user|
  user.name = "userC"
  user.password = "password"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/userC.jpg"), filename:"userC.jpg")
end

Study.find_or_create_by!(title: "教材A") do |study|
  study.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/studyA.jpg"), filename:"studyA.jpg")
  study.user = userA
end

Study.find_or_create_by!(title: "教材B") do |study|
  study.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/studyB.jpg"), filename:"studyB.jpg")
  study.user = userB
end

Study.find_or_create_by!(title: "教材C") do |study|
  study.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/studyC.jpg"), filename:"studyC.jpg")
  study.user = userC
end

puts "seedの実行が完了しました"