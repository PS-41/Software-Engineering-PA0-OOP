# frozen_string_literal: true

# steps that deal with joining the app
# e.g. creating new users

Given('no people have joined the app') do
  # do nothing (assumes starting with empty db)
  nil
end

Given('a person named {string} with username {string} and status {string} has joined') do |name, username, status|
  person = {
    username:,
    password: 'password',
    name:,
    status:
  }
  join_the_app person
end

Given('a person with username {string} has joined') do |username|
  person = {
    username:,
    password: 'password',
    name: 'anonymous',
    status: 'none'
  }
  join_the_app person
end

Given('a person with username {string} and password {string} has joined') do |username, password|
  person = {
    username:,
    password:,
    name: 'anonymous',
    status: 'none'
  }
  join_the_app person
end

Given('a person named {string} ' \
      'with username {string} ' \
      'and password {string} ' \
      'and status {string} has joined') do |name, username, password, status|
  person = {
    username:,
    password:,
    name:,
    status:
  }
  join_the_app person
end

Given('the following people have joined the app in this order:') do |table|
  # wait >1 second between joins so that updates have distinct timestamps
  table.hashes.each do |row|
    person = {
      username: row['username'],
      name: row['name'],
      status: row['status'],
      password: 'password'
    }
    join_the_app person
    sleep(1.01) # seconds
  end
end

When('a person named {string} ' \
     'joins with username {string} ' \
     'and password {string} ' \
     'and status {string}') do |name, username, password, status|
  person = {
    username:,
    password:,
    name:,
    status:
  }
  @output, = join_the_app person
  @username = username
end

When('a person named {string} ' \
     'joins with username {string} ' \
     'and password1 {string} ' \
     'and password2 {string} ' \
     'and status {string}') do |name, username, password1, password2, status|
  # don't use join helper because we need to make an error on purpose: mismatched passwords
  @output, = request('join', stdin_data: "#{username}\n#{password1}\n#{password2}\n#{name}\n#{status}\n")
end

When('I join with username {string}') do |username|
  person = {
    username:,
    password: 'password',
    name: 'anonymous',
    status: 'none'
  }
  @output, = join_the_app person
  @username = username
end

When('I join with username {string} and password {string}') do |username, password|
  person = {
    username:,
    password:,
    name: 'anonymous',
    status: 'none'
  }
  @output, = join_the_app person
  @username = username
end

When('I join with no name') do
  person = {
    username: 'username',
    password: 'password',
    name: '',
    status: 'none'
  }
  @output, = join_the_app person
end

When('I join with name {string}') do |name|
  person = {
    username: 'username',
    password: 'password',
    name:,
    status: 'none'
  }
  @output, = join_the_app person
end

When('I join with no status') do
  person = {
    username: 'username',
    password: 'password',
    name: 'anonymous',
    status: ''
  }
  @output, = join_the_app person
end

When('I join with status {string}') do |status|
  person = {
    username: 'username',
    password: 'password',
    name: 'anonymous',
    status:
  }
  @output, = join_the_app person
end

When('I join with password {string}') do |password|
  person = {
    username: 'username',
    password:,
    name: 'anonymous',
    status: 'do be do be do'
  }
  @output, = join_the_app person
end