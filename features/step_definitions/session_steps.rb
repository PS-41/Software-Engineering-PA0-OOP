# frozen_string_literal: true

# steps that have to do with sessions and sessioon tokens

Given('I have the session token for a person named {string} ' \
      'with username {string} and status {string}') do |name, username, status|
  steps %(
    Given a person named "#{name}" with username "#{username}" and status "#{status}"
  )
  @token = get_token(@output)
end

Given('I have a valid session token') do
  steps %(
    Given a person with username "anon"
  )
  @token = get_token(@output)
end

Then('the new and old session tokens should be the same and non-empty') do
  expect(@token2).to be == @token
  expect(@token).not_to be_empty
  expect(@token).not_to be_nil
end
