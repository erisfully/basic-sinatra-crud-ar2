require "sinatra"
require "active_record"
require "./lib/database_connection"
require "rack-flash"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash


  def initialize
    super
    @database_connection = DatabaseConnection.establish(ENV["RACK_ENV"])
  end

  get "/" do
    if session[:id]
      current_user = @database_connection.sql("SELECT username FROM users WHERE id = #{session[:id]}")[0]["username"]
      erb :loggedin, :locals => {:current_user => current_user}
    else
      erb :home
    end
  end

  post "/" do
    id = @database_connection.sql("SELECT id FROM users WHERE username = '#{params[:username]}'").last["id"]
    session[:id] = id
    p id
    redirect "/"
  end

  get "/register" do
    erb :register
  end

  post "/register" do
    @database_connection.sql("INSERT INTO users (username, password) VALUES ('#{params[:username]}', '#{params[:password]}')")
    flash[:notice] = "Thank you for registering!"
    redirect'/'
  end
end
