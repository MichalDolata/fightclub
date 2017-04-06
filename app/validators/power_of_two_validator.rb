class PowerOfTwoValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors[attribute] << (options[:message] || "is not a power of two") unless (Math.log2(value) % 1).zero?
  end
end