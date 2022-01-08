# frozen_string_literal: true

class User < ActiveRecord::Base
  extend Devise::Models

  devise :database_authenticatable, :registerable,
         :recoverable, :validatable

  include DeviseTokenAuth::Concerns::User

  has_many :links, dependent: :destroy
end
