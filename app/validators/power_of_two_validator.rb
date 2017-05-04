class PowerOfTwoValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.nil? || !(Math.log2(value) % 1).zero?
      record.errors[attribute] << (options[:message] || "is not a power of two")
    end
  end
end