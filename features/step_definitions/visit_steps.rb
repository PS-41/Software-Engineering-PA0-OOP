# frozen_string_literal: true

# steps that have to do with visiting or requesting resources

When('I visit the home page') do
  @output, = request('home')
end

When('I visit the home page with the session token') do
  @output, = request('home', token: @token)
end

When('I visit the home page with an invalid session token') do
  @output, = request('home', token: 'jenny=8675309')
end

When('I visit the {string} page') do |page|
  pages = {
    'show people' => 'people'
  }
  @output, = request(pages[page])
end

When('I visit the {string} page with an invalid session token') do |page|
  @output, = request(page, token: 'KzEgYm9udXM=')
end

When('I visit the show person page for {string} with the session token') do |username|
  @output, = request("show #{username}", token: @token)
end

When('I visit the show person page for {string}') do |username|
  @output, = request("show #{username}")
end

When('I visit the {string} page with the session token') do |page|
  @output, = request(page, token: @token)
end

When('I visit the show person page for nobody') do
  @output, = request('show')
end
