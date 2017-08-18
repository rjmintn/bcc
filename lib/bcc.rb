require 'httparty'
require 'json'
require './lib/roadmap'

class Bcc
  include HTTParty
  include JSON
  include Roadmap

  base_uri 'https://www.bloc.io/api/v1'

  def initialize(e, p)
    values = {body: {
      email: e,
      password: p
    }}

    response = self.class.post("/sessions", values)
    @token = response['auth_token']
    puts response['message'] if @token.nil?
  rescue => e
    puts e
  end

  def get_me
    options = {headers: { "authorization" => @token}}
    response = self.class.get('/users/me', options)
    response['current_enrollment']['mentor_id']
    # puts response
    response_to_file("get_me", response)
  end

  def get_mentor_availability (mentor_id)
    addr  = "/mentors/#{mentor_id}/student_availability"
    options = {headers: { "authorization" => @token}, body: {id: 0}}
    response = self.class.get(addr, options)
    # puts response
    # response_to_file("mentor_availability", response)
    # puts response.to_a
    availability = []
    response.each do |r|
      availability << Array(r)
    end
    # puts availability
  end

  def get_messages(page_num = 1000)

    addr  = "/message_threads"
    options = {headers: { "authorization" => @token}, body: {"page": page_num}}
    @response = self.class.get(addr, options)
    if page_num == 1000
      pages = (@response['count']/10)+1
      pages.times do |page_num|
        page_num += 1
        response = self.class.get(addr, {headers: { "authorization" => @token}, body: {"page": page_num}})
        @response['items'] += response['items']
      end
     end
    response_to_file("messages", @response['items'])
  end

  def create_message(sender, recipient_id, token, subject, text)
    addr  = "/messages"
    options = {
      headers: {
        "authorization" => @token
      },
      body: {
        "sender": sender,
        "recipient_id": recipient_id,
        "token": token,
        "subject": subject,
        "stripped-text": text
        }
      }
    response = self.class.get(addr, options)

  end



  private
  def response_to_file(name, jsondata)
    File.open("#{name}.js","w") do |f|
      f.write(jsondata)
    end
  end

end


n = Bcc.new("rjmorawski@gmail.com", "wd212dr1")
n.get_me
# mentor_id = 539470
# n.get_mentor_availability(mentor_id)
# n.get_roadmap(37)
# n.get_checkpoint(2295)
n.get_messages(2) #selected message page
n.get_messages  #all messages
n.create_message("rjmorawski@gmail.com", nil, "3c56603e-c6dc-4a69-9e4e-c105cb651b63", "")
