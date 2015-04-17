require 'sinatra'
require 'data_mapper'

DataMapper.setup(:default, 'postgres://localhost/play')

require './app/models/user'
require './app/models/peep'

DataMapper.finalize
DataMapper.auto_upgrade!

enable :sessions

get '/' do
  @username = session[:username]
  @peeps = Peep.all
  erb :index
end

post '/sessions/new' do
  session[:username] = params[:username]
  user = User(username: params[:username])
  redirect '/'
end

post '/peeps/new' do
  redirect '/'
end

get '/users/new' do
  erb :users
end

post '/users/new' do
  user = User.new username: params[:username],
                  name: params[:name],
                  password: params[:password],
                  password_confirmation: params[:password_confirmation]
  user.save #create the user object and then if there is an issue it lets you know why its false
  session[:user_id] = user.id
  redirect '/'
end
