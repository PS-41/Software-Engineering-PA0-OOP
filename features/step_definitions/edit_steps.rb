# frozen_string_literal: true

# steps for editing

When('I go to edit but I don\'t change anything') do
  # wait a bit to see if timestamp changes (it should not)
  sleep(1.01) # seconds
  @output, = request('edit', token: @token, stdin_data: "\n\n")
end

When('I edit my name to be {string}') do |name|
  # wait a bit to make sure timestamp changes
  sleep(1.01) # seconds
  @output, = request('edit', token: @token, stdin_data: "#{name}\n\n")
end

When('I edit my status to be {string}') do |status|
  # wait a bit to make sure timestamp changes
  sleep(1.01) # seconds
  @output, = request('edit', token: @token, stdin_data: "\n#{status}\n")
end

When('I edit my name to be {string} and my status to be {string}') do |name, status|
  # wait a bit to make sure timestamp changes
  sleep(1.01) # seconds
  @output, = request('edit', token: @token, stdin_data: "#{name}\n#{status}\n")
end

When('I request edit without a session token') do
  @output, = request('edit')
end
