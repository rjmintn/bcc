require 'httparty'
require 'json'

class Bcc
  include HTTParty
  include JSON
  base_uri 'https://www.bloc.io/api/v1'

  def initialize(e, p)
    values = {body: {
      email: e,
      password: p
    },
  }
    response = self.class.post("/sessions", values)
    @token = response['auth_token']
    puts response['message'] if @token.nil?
  rescue => e
    puts e
  end

  def get_me
    options = {headers: { "authorization" => @token}}
    response = self.class.get('/users/me', options)
  end


end





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
