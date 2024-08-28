# frozen_string_literal: true

# steps for creating people

Given('a person named {string} with username {string} and password {string} and status {string}') do |name, username, password, status|
  @output, = request("create username=\"#{username}\" password=\"#{password}\" name=\"#{name}\" status=\"#{status}\"")
end

Given('a person with username {string}') do |username|
  steps %(
    Given a person named "anonymous" with username "#{username}" and password "password" and status "none"
  )
end

Given('a person with username {string} was created') do |username|
  steps %(
    Given a person with username "#{username}"
  )
end

Given('a person with username {string} and password {string}') do |username, password|
  if username.include?('"')
    if password.include?('"')
      steps %(
        Given a person named "anonymous" with username '#{username}' and password '#{password}' and status "none"
      )
    else
      steps %(
        Given a person named "anonymous" with username '#{username}' and password "#{password}" and status "none"
      )
    end
  else
    if password.include?('"')
      steps %(
        Given a person named "anonymous" with username "#{username}" and password '#{password}' and status "none"
      )
    else
      steps %(
        Given a person named "anonymous" with username "#{username}" and password "#{password}" and status "none"
      )
    end
  end

end

Given('a person named {string} with username {string} and status {string}') do |name, username, status|
  steps %(
    Given a person named "#{name}" with username "#{username}" and password "password" and status "#{status}"
  )
end

Given('the following people:') do |table|
  table.hashes.each do |row|
    steps %(
      Given a person named "#{row['name']}" with username "#{row['username']}" and password "#{row['password']}" and status "#{row['status']}"
    )
  end
end


When('I create a person with name {string} and username {string} and password {string} and status {string}') do |name, username, password, status|
  steps %(
    Given a person named "#{name}" with username "#{username}" and password "#{password}" and status "#{status}"
  )
end

When('I create a person with username {string}') do |username|
  if username.include?('"')
    steps %(
      Given a person named "anonymous" with username '#{username}' and password "password" and status "none"
    )
  else
    steps %(
      Given a person named "anonymous" with username "#{username}" and password "password" and status "none"
    )
  end
end

When('I create a person with name {string}') do |name|
  if name.include?('"')
    steps %(
      Given a person named '#{name}' with username "anon" and password "****" and status "none"
    )
  else
    steps %(
      Given a person named "#{name}" with username "anon" and password "****" and status "none"
    )
  end
end

When('I create a person with status {string}') do |status|
  if status.include?('"')
    steps %(
      Given a person named "Anonymous" with username "anon" and password "****" and status '#{status}'
    )
  else
    steps %(
      Given a person named "Anonymous" with username "anon" and password "****" and status "#{status}"
    )
  end
end

When('I create a person with password {string}') do |password|
  if password.include?('"')
    steps %(
      Given a person with username "anon" and password '#{password}'
    )
  else
    steps %(
      Given a person with username "anon" and password "#{password}"
    )
  end
end

When('I create a person with username {string} and password {string}') do |username, password|
  if username.include?('"')
    if password.include?('"')
      steps %(
        Given a person with username '#{username}' and password '#{password}'
      )
    else
      steps %(
        Given a person with username '#{username}' and password "#{password}"
      )
    end
  else
    if password.include?('"')
      steps %(
        Given a person with username "#{username}" and password '#{password}'
      )
    else
      steps %(
        Given a person with username "#{username}" and password "#{password}"
      )
    end
  end
end
