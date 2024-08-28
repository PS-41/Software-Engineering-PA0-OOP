# frozen_string_literal: true

# steps for sorting

When('I sort by {string}') do |string|
  if string.empty?
    @output, = request('sort')
  else
    @output, = request("sort #{string}")
  end
end
