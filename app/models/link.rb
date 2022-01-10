# frozen_string_literal: true

class Link < ApplicationRecord
  belongs_to :user

  validates :url, presence: true, url: true
  validates :slug, presence: true, slug: true

  scope :active, -> { where.not(id: expired.ids) }
  scope :expired, -> { where('expires_at <= ?', Time.zone.now) }
end
