require 'sinatra'
require 'data_mapper'

DataMapper.setup(:default, 'postgres://localhost/play')

require './app/models/user'
require './app/models/peep'
require_relative 'helpers/application'

DataMapper.finalize
DataMapper.auto_upgrade!

enable :sessions
set :session_secret, 'super secret'

get '/' do
  @peeps = Peep.all
  erb :index
end

post '/sessions/new' do
  user = User.first(username: params[:username])
  session[:user_id] = user.id
  redirect '/'
end

post '/peeps/new' do
  current_user.peeps.create(text: params[:peep])
  redirect '/'
end

get '/users/new' do
  erb :users
end

post '/users/new' do
  @user = User.new username: params[:username],
                     name: params[:name],
                     password: params[:password],
                     password_confirmation: params[:password_confirmation]
  if @user.save #create the user object and then if there is an issue it lets you know why its false
    session[:user_id] = @user.id
    redirect '/'
  else
    redirect '/users/new'
  end
end
