# frozen_string_literal: true

# steps for seeing (checking output)

Then('I should see {string}') do |string|
  if string.include? '<session>'
    pattern = Regexp.new(string.sub('<session>', 'session [A-Za-z0-9+\/]*={0,2}'))
    expect(@output).to match(pattern)
  else
    string.sub! '<token>', @token if string.include? '<token>'
    expect(@output).to include(string)
  end
end

Then('I should not see {string}') do |string|
  expect(@output).not_to include(string)
end

Then('I should see {string} before {string}') do |string1, string2|
  expect(@output).to match(Regexp.new("#{Regexp.escape(string1)}(.|\n)*#{Regexp.escape(string2)}"))
end

Then('I should see the show person page for {string} with name {string} and status {string}') do |username, name, status|
  expect(@output).to include("Person")
  expect(@output).to include("username: #{username}")
  expect(@output).to include("name: #{name}")
  expect(@output).to include("status: #{status}")
  expect(@output).to include("updated: ")
  expect(@output).to include("people: ")
  expect(@output).to include("home: ")
end
