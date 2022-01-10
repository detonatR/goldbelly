# frozen_string_literal: true

class Slugger
  def self.generate(**args)
    new(**args).generate
  end

  def initialize(user: nil, url: nil, custom_slug: nil, expires_at: nil)
    @user = user
    @url = url
    @custom_slug = custom_slug
    @expires_at = expires_at
  end

  def generate
    Link.new(
      user: @user,
      url: normalized_url,
      slug: slug_candidate,
      expires_at: @expires_at
    )
  end

  private

  def normalized_url
    return if @url.nil?

    @url.gsub(/\s+/, '').downcase
  end

  def slug_candidate
    @custom_slug || generate_slug
  end

  def generate_slug
    loop do
      string = SecureRandom.uuid[0..5]
      break string unless Link.to_adapter.find_first({ slug: string })
    end
  end
end
