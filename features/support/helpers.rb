# frozen_string_literal: true

require 'open3'

def request(resource, params = {})
  # helper method to make a request
  command = "./app '"
  command += "session #{params[:token]} " if params.key? :token
  command += "#{resource.gsub("'", "'\\\\''")}'"
  if params.key? :stdin_data
    Open3.capture2(command, stdin_data: params[:stdin_data])
  else
    Open3.capture2(command)
  end
end

def join_the_app(person)
  # helper method to add a person to the app
  username = person[:username]
  password = person[:password]
  name = person[:name]
  status = person[:status]
  request('join', stdin_data: "#{username}\n#{password}\n#{password}\n#{name}\n#{status}\n")
end

def get_token(response)
  m = %r{session (?<token>[A-Za-z0-9+/]*={0,2})}.match(response)
  m.named_captures['token'] unless m.nil?
end

def get_timestamp(response)
  m = /updated: (?<timestamp>\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2})/.match(response)
  m.named_captures['timestamp'] unless m.nil?
end
