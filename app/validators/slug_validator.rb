# frozen_string_literal: true

class SlugValidator < ActiveModel::EachValidator
  SLUG_REGEXP = /^[A-Za-z0-9]+$/

  def validate_each(record, attribute, value)
    return if value.blank?

    check_uniqueness(value, record, attribute)
    check_format(value, record, attribute)
  end

  private

  def check_uniqueness(value, record, attribute)
    query = record.class.where(attribute => value)
    query = query.where.not(id: record.id) if record.persisted?

    record.errors.add(attribute, :taken) unless query.count.zero?
  end

  def check_format(value, record, attribute)
    record.errors.add(attribute, :invalid) unless SLUG_REGEXP.match?(value)
  end
end
