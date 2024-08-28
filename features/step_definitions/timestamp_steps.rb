# frozen_string_literal: true

# steps having to do with timestamps

When('I take note of my last updated timestamp') do
  output, = request("show #{@username}")
  @timestamp = get_timestamp(output)
end

Then('the timestamp should be updated') do
  output, = request("show #{@username}")
  timestamp2 = get_timestamp(output)
  expect(timestamp2).not_to be == @timestamp
end

Then('the timestamp should not be updated') do
  output, = request("show #{@username}")
  timestamp2 = get_timestamp(output)
  expect(timestamp2).to be == @timestamp
end
