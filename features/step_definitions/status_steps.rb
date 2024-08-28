# frozen_string_literal: true

# steps for statuses

Then('I should see the following status:') do |table|
  data = table.raw
  pattern = Regexp.new(
    "#{Regexp.escape(data[0][0])}\n  " \
    "#{Regexp.escape(data[1][0])}\n  " \
    '@ \\d{4}-\\d{2}-\\d{2} \\d{2}:\\d{2}:\\d{2}'
  )
  expect(@output).to match(pattern)
end
