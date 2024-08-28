# frozen_string_literal: true

# steps having to do with logging out

When('I logout with the session token') do
  @output, = request('logout', token: @token)
end

When('I logout without a session token') do
  @output, = request('logout')
end

When('I logout with an invalid session token') do
  @output, = request('logout', token: 's8e6s7s5i3o0n9')
end
