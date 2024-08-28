# frozen_string_literal: true

# steps that have to do with logging in

Given('I am not logged in') do
  @token = ''
end

When('I login as {string} with password {string}') do |username, password|
  @output, = request("login #{username} #{password}")
  @token = get_token(@output)
  @username = username
end

When('I login as {string} with password {string} and get a new session token') do |username, password|
  @output, = request("login #{username} #{password}")
  @token2 = get_token(@output)
  @username = username
end

When('I login as {string} with no password') do |username|
  @output, = request("login #{username}")
end

When('I login with no username or password') do
  @output, = request('login')
end
