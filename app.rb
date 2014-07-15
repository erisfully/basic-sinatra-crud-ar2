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
      user_list = @database_connection.sql("SELECT username FROM users WHERE username <> '#{current_user}'")
      erb :loggedin, :locals => {:current_user => current_user, :user_list => user_list}
    else
      erb :home
    end
  end

  get "/logout" do
    session.delete(:id)
    redirect "/"
  end

  post "/" do
    id = @database_connection.sql("SELECT id FROM users WHERE username = '#{params[:username]}'").last["id"]
    session[:id] = id
    redirect "/"
  end

  get "/register" do
    erb :register
  end

  post "/register" do
      check_register(params[:username], params[:password])
  end


  private

  def check_register(username, password)
    if user_exists(username) != []
      flash[:notice] = "That username already exists"
      redirect "/register"
    elsif username == ""  && password != ""
      flash[:notice] = "Username required"
      redirect "/register"
    elsif username != "" && password == ""
      flash[:notice] = "Password required"
      redirect "/register"
    elsif username == "" && password == ""
      flash[:notice] = "Username and password required"
      redirect "/register"
    else
      @database_connection.sql("INSERT INTO users (username, password) VALUES ('#{params[:username]}', '#{params[:password]}')")
      flash[:notice] = "Thank you for registering!"
      redirect'/'
    end

  end

  def user_exists (username)
    @database_connection.sql("SELECT username FROM users WHERE username = '#{username}'")
  end
end
