ENV["RACK_ENV"] ||= "development"

require 'sinatra/base'
require 'sinatra/flash'
require './app/dmconfig.rb'

class ChitterChallenge < Sinatra::Base
  enable :sessions
  set :session_secret, 'super secret'
  register Sinatra::Flash

  helpers do
    def current_user
      @current_user ||= User.get(session[:user_id])
    end
  end

  get '/' do
    redirect '/users/new'
  end

  get '/users/new' do
    erb :'users/new'
  end

  post '/users' do
    @user = User.create(email: params[:user_email],
      password: params[:user_password],
      password_confirmation: params[:password_confirmation],
      name: params[:name],
      username: params[:username])
    if @user.save
      session[:user_id] = @user.id
      redirect '/peeps'
    else
      flash.now[:errors] = @user.errors.full_messages
      erb :'users/new'
    end
  end

  get '/peeps' do
    erb :'users/new'
  end

  # start the server if ruby file executed directly
  run! if app_file == $0
end
