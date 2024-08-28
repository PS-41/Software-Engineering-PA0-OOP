When('I request {string}') do |request|
  @output, = request(request)
end

When('I request {string} with the session token') do |request|
  @output, = request(request, token: @token)
end

When('I request nothing') do
  @output, = Open3.capture2('./app')
end