# frozen_string_literal: true

# steps for deleting

When('I delete my account') do
  @output, = request('delete', token: @token)
end

When('I request delete without a session token') do
  @output, = request('delete')
end
