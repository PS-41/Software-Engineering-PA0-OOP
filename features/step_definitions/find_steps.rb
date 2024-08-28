# frozen_string_literal: true

# steps for searching

When('I search for {string}') do |string|
  @output, = request("find #{string}")
end
