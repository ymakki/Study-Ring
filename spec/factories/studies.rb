FactoryBot.define do
  factory :study do
    title { Faker::Lorem.characters(number: 5) }
    user

    after(:build) do |study|
      study.image.attach(io: File.open('spec/images/image.jpg'), filename: 'image.jpg')
    end
  end
end
