# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { 'ThisPasswordShouldNotBeGuessed23$' }
    password_confirmation { 'ThisPasswordShouldNotBeGuessed23$' }
  end
end
