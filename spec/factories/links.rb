# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    user
    url { Faker::Internet.url }
    expires_at { 2.days.from_now(Time.zone.now) }
  end
end
