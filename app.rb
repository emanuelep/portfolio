require 'haml'
require 'sass'
require 'sinatra/base'
require 'sinatra/reloader'

path = File.expand_path "../", __FILE__
APP_PATH = path

class App < Sinatra::Base
  require "#{APP_PATH}/config/env"
  
  configure :development do # use thin start
    register Sinatra::Reloader
    also_reload ["controllers/*.rb", "models/*.rb"]
    set :public, "public"
    set :static, true
  end
  
  set :haml, { :format => :html5 }
  require 'rack-flash'
  enable :sessions
  use Rack::Flash
  require 'sinatra/content_for'
  helpers Sinatra::ContentFor
  set :method_override, true

  def not_found(object=nil)
    halt 404, "404 - Page Not Found"
  end

  get "/" do
    haml :home
  end


  get "/users" do
    haml :users
  end

  get "/contacts" do
    haml :contacts
  end

  get '/css/main.css' do
    sass :main
  end
  
  
  post "/login" do

    user = User.first( name: params[:username] )
    if user
      if user.password == params[:password]      
        # settare la sessione
        redirect "/login_effettuato"
      end
    end
    
  end
  
  configure :development do
    get "/migrate"do
      DataMapper.auto_migrate!
      "migrated! <a href='/'>go back home</a>"
    end
  end
  
end