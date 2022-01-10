# frozen_string_literal: true

json.array! @links do |link|
  json.id link.id
  json.url link.url
  json.shorten_url short_url(slug: link.slug)
  json.expires_at link.expires_at
end
