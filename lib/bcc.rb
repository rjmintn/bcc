require 'httparty'
class Bcc
  include HTTParty
  base_uri 'https://www.bloc.io/api/v1'

  def initialize(e, p)
    values = {body: {
      email: e,
      password: p
    }}
    response = self.class.post("/sessions", values)
    puts response['auth_token'] || response['message']
  rescue => e
    puts e
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
