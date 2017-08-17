require 'httparty'
require 'json'

class Bcc
  include HTTParty
  include JSON
  base_uri 'https://www.bloc.io/api/v1'

  def initialize(e, p)
    # values = {headers: { "content_type" => 'application/json' }, body: {
    #   email: e,
    #   password: p
    # }}
    @count = 0
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
    # puts response.to_a  
    availability = []
    response.each do |r|
      availability << Array(r)
    end
    puts availability
  end


  private
  def response_to_file(jsondata)
    @count += 1
    File.open("output-#{@count}.js","w") do |f|
      f.write(jsondata)
    end
  end

end


n = Bcc.new("rjmorawski@gmail.com", "wd212dr1")
n.get_me
mentor_id = 539470
n.get_mentor_availability(mentor_id)


  # require 'httparty'
  # require 'json'
  #
  #     values = {body: {
  #       "email": "rjmorawski@gmail.com",
  #       "password": "wd212dr1"
  #     }}
  #
  # response = HTTParty.post('https://www.bloc.io/api/v1/sessions', values)
  # puts JSON.pretty_generate(response)
  # puts response
