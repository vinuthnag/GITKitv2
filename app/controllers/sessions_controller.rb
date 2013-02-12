class SessionsController < ApplicationController
  
  require 'uri'
  require 'restclient'
  protect_from_forgery :except => :toolkit_oauth_callback


  def home_page

  end

  def new
    render :layout => 'login_layout'
  end

  def login
    session[:user] = true
    render :json => {"status" => "OK"}
  end

  def logout
    session[:user] = nil
    redirect_to "/"
  end

  def user_status
    render :json => {:registered => true}, :layout => false
  end

  def toolkit_oauth_callback
    api_params = {
      'requestUri' => request.url,
      'postBody' => request.post? ? request.raw_post : URI.parse(request.url).query
    }
    
    api_url = "https://www.googleapis.com/identitytoolkit/v1/relyingparty/" +
      "verifyAssertion?key=AIzaSyB3VZOahFVjE9Do5hmhPypDukCC5xGsmCM"
    
    assertion = get_assertion(api_url, api_params)
    
    unless assertion.nil?
      session[:user] = {:first_name => assertion["firstName"], :last_name => assertion["lastName"], :display_name => assertion["displayName"], :email => assertion["verifiedEmail"], :image => assertion["photoUrl"] || "https://dev.weunite.com/images/avatar.png"}
    else
      redirect_to "/" and return
    end
    render :layout => false
  end

  private

  def get_assertion(url, params)
    begin
      api_response = RestClient.post(url, params.to_json, :content_type => :json )
      verified_assertion = JSON.parse(api_response)
      raise StandardError unless verified_assertion.include? "verifiedEmail"
      return verified_assertion
    rescue StandardError => error
      return nil
    end
  end

end
