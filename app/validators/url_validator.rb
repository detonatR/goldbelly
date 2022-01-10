# frozen_string_literal: true

require 'uri'

class UrlValidator < ActiveModel::EachValidator
  URL_REGEXP = %r{https?://(www\.)?[-a-zA-Z0-9@:%._+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_+.~#?&/=]*)}

  def validate_each(record, attribute, value)
    return if value.blank?

    begin
      uri = URI.parse(value)

      check_host(uri, record, attribute)
      check_schema(uri, record, attribute)
      check_structure(value, record, attribute)
    rescue URI::InvalidURIError
      record.errors.add(attribute, :not_parsable)
    end
  end

  private

  def check_host(uri, record, attribute)
    host = uri.host

    if host.blank?
      record.errors.add(attribute, :blank_host)
    elsif host.exclude?('.')
      record.errors.add(attribute, :incomplete_domain)
    end
  end

  def check_schema(uri, record, attribute)
    record.errors.add(attribute, :blank_schema) unless %w[http https].include? uri.scheme
  end

  def check_structure(url, record, attribute)
    record.errors.add(attribute, :invalid_url) unless URL_REGEXP.match?(url)
  end
end
