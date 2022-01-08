# frozen_string_literal: true

class Link < ApplicationRecord
  belongs_to :user

  validates :url, presence: true, uniqueness: { case_sensitive: true }

  scope :active, -> { where.not(id: expired.ids) }
  scope :expired, -> { where.not(expires_at: nil).where('expires_at <= ?', Time.zone.now) }

  before_save :generate_slug!

  private

  def generate_slug!
    return if slug.present?

    self.slug = loop do
      string = SecureRandom.uuid[0..5]
      break string unless Link.to_adapter.find_first({ slug: string })
    end
  end
end
