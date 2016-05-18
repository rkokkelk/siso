Rails.application.routes.draw do
  root 'main#index'

  # Error pages, first otherwise confused with repo
  get '/404', to: 'main#page_not_found'
  get '/422', to: 'main#unprocessable_entity'
  get '/429', to: 'main#retry_later'
  get '/500', to: 'main#server_error'

  # Repositories
  get    'new',               to:     'repositories#new'
  post   'new',               to:     'repositories#create'
  get    ':id/authenticate',  to:     'repositories#show_authenticate'
  post   ':id/authenticate',  to:     'repositories#authenticate'
  get    ':id',               to:     'repositories#show'
  delete ':id',               to:     'repositories#delete'
  get    ':id/audit',         to:     'repositories#audit'

  # File Records
  get    ':id/:record_id',    to:     'records#show'
  put    ':id/record',        to:     'records#create'
  delete ':id/:record_id',    to:     'records#delete'
end
