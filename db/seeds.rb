# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

puts "seedの実行を開始"

Admin.find_or_create_by!(email: 'admin@admin') do |admin|
  admin.password = 'testtest'
end

userA = User.find_or_create_by!(email: "usera@example.com") do |user|
  user.name = "userA"
  user.password = "password"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/userA.jpg"), filename:"userA.jpg")
  user.introduction = "最近はじめました！"
  user.follow_request = 0
  user.sex = 1
  user.birthday = "2004-03-19"
  user.residence = 22
  user.is_active = true
end

userB = User.find_or_create_by!(email: "userb@example.com") do |user|
  user.name = "userB"
  user.password = "password"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/userB.jpg"), filename:"userB.jpg")
  user.introduction = "勉強大変だけど、頑張ろう"
  user.follow_request = 1
  user.sex = 1
  user.birthday = "2004-08-27"
  user.residence = 40
  user.is_active = true
end

userC = User.find_or_create_by!(email: "userc@example.com") do |user|
  user.name = "userC"
  user.password = "password"
  user.profile_image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/userC.jpg"), filename:"userC.jpg")
  user.introduction = "ちょっと休憩しよう"
  user.follow_request = 2
  user.sex = 1
  user.birthday = "2002-01-09"
  user.residence = 14
  user.is_active = true
end

studyA = Study.find_or_create_by!(title: "教材A") do |study|
  study.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/studyA.jpg"), filename:"studyA.jpg")
  study.user = userA
  study.status = 0
end

studyB = Study.find_or_create_by!(title: "教材B") do |study|
  study.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/studyB.jpg"), filename:"studyB.jpg")
  study.user = userB
  study.status = 1
end

studyC = Study.find_or_create_by!(title: "教材C") do |study|
  study.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/studyC.jpg"), filename:"studyC.jpg")
  study.user = userC
  study.status = 2
end

Study.find_or_create_by!(title: "教材D") do |study|
  study.image = ActiveStorage::Blob.create_and_upload!(io: File.open("#{Rails.root}/db/fixtures/studyD.jpg"), filename:"studyD.jpg")
  study.user = userA
  study.status = 1
end

recordA = Record.find_or_create_by!(study_time: 60, start_time: Time.zone.now) do |record|
  record.word = "頑張りました！"
  record.user = userA
  record.study = studyA
end

recordB = Record.find_or_create_by!(study_time: 80, start_time: Time.zone.now) do |record|
  record.word = "まだまだこれから！"
  record.user = userB
  record.study = studyB
end

recordC = Record.find_or_create_by!(study_time: 120, start_time: Time.zone.now) do |record|
  record.word = "難しかった！"
  record.user = userC
  record.study = studyC
end

Favorite.find_or_create_by!(user: userB, record: recordA)

Favorite.find_or_create_by!(user: userA, record: recordB)

Favorite.find_or_create_by!(user: userB, record: recordC)

StudyComment.find_or_create_by!(comment: "頑張ってください!") do |study_comment|
  study_comment.user = userB
  study_comment.record = recordA
end

StudyComment.find_or_create_by!(comment: "難しそう") do |study_comment|
  study_comment.user = userA
  study_comment.record = recordB
end

StudyComment.find_or_create_by!(comment: "自分もやってみます!") do |study_comment|
  study_comment.user = userB
  study_comment.record = recordC
end

study_reviewA = StudyReview.find_or_create_by!(title: "初心者におススメ", body: "コツコツ続けましょう!") do |study_review|
  study_review.user = userA
  study_review.study = studyA
end

study_reviewB = StudyReview.find_or_create_by!(title: "難しいけど力がつく!", body: "頑張りましょう!") do |study_review|
  study_review.user = userB
  study_review.study = studyB
end

study_reviewC = StudyReview.find_or_create_by!(title: "ちょっと物足りないかも", body: "内容は分かりやすく丁寧ですよ！") do |study_review|
  study_review.user = userC
  study_review.study = studyC
end

ReviewFavorite.find_or_create_by!(user: userB, study_review: study_reviewA)

ReviewFavorite.find_or_create_by!(user: userA, study_review: study_reviewB)

ReviewFavorite.find_or_create_by!(user: userB, study_review: study_reviewC)

ReviewComment.find_or_create_by!(comment: "これいいですよね！") do |review_comment|
  review_comment.user = userB
  review_comment.study_review = study_reviewA
end

ReviewComment.find_or_create_by!(comment: "難しかったです") do |review_comment|
  review_comment.user = userA
  review_comment.study_review = study_reviewB
end

ReviewComment.find_or_create_by!(comment: "とても分かりやすかったです") do |review_comment|
  review_comment.user = userB
  review_comment.study_review = study_reviewC
end

Timeline.find_or_create_by!(record: recordA, user_id: recordA.user.id)

Timeline.find_or_create_by!(record: recordB, user_id: recordB.user.id)

Timeline.find_or_create_by!(record: recordC, user_id: recordC.user.id)

Timeline.find_or_create_by!(study_review: study_reviewA, user_id: study_reviewA.user.id)

Timeline.find_or_create_by!(study_review: study_reviewB, user_id: study_reviewB.user.id)

Timeline.find_or_create_by!(study_review: study_reviewC, user_id: study_reviewC.user.id)

Relationship.find_or_create_by!(follower: userB, followed: userA)

Relationship.find_or_create_by!(follower: userC, followed: userA)

Relationship.find_or_create_by!(follower: userA, followed: userB)

Relationship.find_or_create_by!(follower: userA, followed: userC)

tagA = Tag.find_or_create_by!(name: "Ruby") do |tag|
  tag.user = userA
end

tagB = Tag.find_or_create_by!(name: "Java") do |tag|
  tag.user = userB
end

tagC = Tag.find_or_create_by!(name: "Python") do |tag|
  tag.user = userC
end

StudyTagging.find_or_create_by!(study: studyA, tag: tagA)

StudyTagging.find_or_create_by!(study: studyB, tag: tagB)

StudyTagging.find_or_create_by!(study: studyC, tag: tagC)

UserTagging.find_or_create_by!(user: userA, tag: tagA)

UserTagging.find_or_create_by!(user: userB, tag: tagB)

UserTagging.find_or_create_by!(user: userC, tag: tagC)

room1 = Room.find_or_create_by!(id: 1)

Entry.find_or_create_by!(user: userA, room: room1)

Entry.find_or_create_by!(user: userB, room: room1)

Message.find_or_create_by!(content: "よろしくお願いします!") do |message|
  message.user = userA
  message.room = room1
end

Message.find_or_create_by!(content: "こちらこそお願いします!") do |message|
  message.user = userB
  message.room = room1
end

puts "seedの実行が完了しました"