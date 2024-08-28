# frozen_string_literal: true

# steps for updating

When('I update the person to have name {string} and status {string}') do |name, status|
  @output, = request("update name=\"#{name}\" status=\"#{status}\"", token: @token)
end

When('I update the person to have name {string}') do |name|
  @output, = request("update name=\"#{name}\"", token: @token)
end

When('I update the person to have status {string}') do |status|
  @output, = request("update status=\"#{status}\"", token: @token)
end

When('I request update with no parameters') do
  @output, = request("update", token: @token)
end

When('I request update without a session token') do
  @output, = request('update')
end
