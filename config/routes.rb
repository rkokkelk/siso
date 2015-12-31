Rails.application.routes.draw do
  root   'main#index'

  # Repositories
  get    'repositories/new'                     => 'repositories#new'
  post   'repositories'                         => 'repositories#create'
  get    'repositories/:id/authenticate'        => 'repositories#show_authenticate'
  post   'repositories/:id/authenticate'        => 'repositories#authenticate'
  get    'repositories/:id'                     => 'repositories#show'

  # File Records
  get    'repositories/:id/record/:record_id'   => 'records#show'
  put    'repositories/:id/record'              => 'records#create'
  delete 'repositories/:id/record/:record_id'   => 'records#delete'

  # Error pages
  get '404', :to => 'main#page_not_found'
  get '500', :to => 'main#server_error'
end
