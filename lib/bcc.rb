require 'httparty'
require 'json'
require './lib/roadmap'

class Bcc
  include HTTParty
  debug_output $stderr
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
  end

  def get_mentor_availability (mentor_id)
    addr  = "/mentors/#{mentor_id}/student_availability"
    options = {headers: { "authorization" => @token}, body: {id: 0}}
    response = self.class.get(addr, options)
    availability = []
    response.each do |r|
      availability << Array(r)
    end
    puts availability
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
    else
      @response = self.class.get(addr, {headers: { "authorization" => @token}, body: {"page": page_num}})
    end
    puts @response['items']
  end

  def create_message(sender, recipient_id, token, subject, text)
    addr  = "/messages"
    options = {
      headers: {
        "authorization" => @token
      },
      body: {
        "sender": 'rjmorawski@gmail.com',
        "recipient_id": 539470,
        # "token": '3c56603e-c6dc-4a69-9e4e-c105cb651b63',
        "subject": '404',
        "stripped-text": 'Say 404 one more time. I dare you. I double dare you. Sent from the BCC api client.'
        }
      }
    response = self.class.post("/messages", options)
  end

  def get_mentor_list
    addr  = "/mentors/#{mentor_id}/student_availability"
    options = {headers: { "authorization" => @token}, body: {id: 0}}
    response = self.class.get(addr, options)
  end

  def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment)
    addr = "/checkpoint_submissions"
    options = {headers: { "authorization" => @token}, body:{
      assignment_branch: assignment_branch,
      assignment_commit_link: assignment_commit_link,
      checkpoint_id: checkpoint_id,
      comment: comment,
      enrollment_id: 29059,
      work_commit_link:""
      }}
      response = self.class.post(addr, options)
      response_to_file("submit_checkpoint", response)
  end

  def update_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment)
    addr = "/checkpoint_submissions/217202"
    options = {headers: { "authorization" => @token}, body:{
      assignment_branch: assignment_branch,
      assignment_commit_link: assignment_commit_link,
      checkpoint_id: checkpoint_id,
      comment: comment,
      enrollment_id: 29059,
      id: 217202,
      work_commit_link:""
      }}
      response = self.class.put(addr, options)
      response_to_file("submit_checkpoint", response)
  end


  private
  def response_to_file(name, jsondata)
    File.open("#{name}.js","w") do |f|
      f.write(jsondata)
    end
  end

end
