Rails.application.routes.draw do
  root   'main#index'

  # Error pages, first otherwise confused with repo
  get '/404', :to => 'main#page_not_found'
  get '/422', :to => 'main#unprocessable_entity'
  get '/429', :to => 'main#retry_later'
  get '/500', :to => 'main#server_error'

  # Repositories
  get    'new'                     => 'repositories#new'
  post   'new'                     => 'repositories#create'
  get    ':id/authenticate'        => 'repositories#show_authenticate'
  post   ':id/authenticate'        => 'repositories#authenticate'
  get    ':id'                     => 'repositories#show'
  delete ':id'                     => 'repositories#delete'
  get    ':id/audit'               => 'repositories#audit'

  # File Records
  get    ':id/:record_id'          => 'records#show'
  put    ':id/record'              => 'records#create'
  delete ':id/:record_id'          => 'records#delete'
end
