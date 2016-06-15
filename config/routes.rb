# Match IDs with dots in them
id_pattern = /[^\/]+/

ResqueWeb::Engine.routes.draw do

  ResqueWeb::Plugins.plugins.each do |p|
    mount p::Engine => p.engine_path
  end

  resource  :overview,  :only => [:show], :controller => :overview
  resources :working,   :only => [:index]
  resources :queues,    :only => [:index,:show,:destroy], :constraints => {:id => id_pattern} do
    member do
      put 'clear'
    end
  end
  resources :workers,   :only => [:index,:show], :constraints => {:id => id_pattern}
  resources :failures,  :only => [:show,:index,:destroy] do
    member do
      put 'retry'
    end
    collection do
      put 'retry_all'
      delete 'destroy_all'
    end
  end

  get '/stats' => "stats#index"
  get '/stats/resque',      :controller => :stats, :action => :resque
  get '/stats/redis',       :controller => :stats, :action => :redis
  get '/stats/keys',        :controller => :stats, :action => :keys
  get '/stats/resque/:id',  :controller => :stats, :action => :resque, :constraints => {:id => id_pattern}, :as => :resque_statistic
  get '/stats/redis/:id',   :controller => :stats, :action => :redis,  :constraints => {:id => id_pattern}, :as => :redis_statistic
  get '/stats/keys/:id',    :controller => :stats, :action => :keys,   :constraints => {:id => id_pattern}, :as => :keys_statistic

  root :to => 'overview#show'

end
