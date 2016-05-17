class ApplicationController < ActionController::Base
  include I18n

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Standard input validation actions
  before_action :verify_tokens

  def ip_authentication
    unless IpHelper.verifyIP request.remote_ip
      redirect_to(controller: :main, action: :index)
    end
  end

  def authentication
    # Verify if the use can access the requested repository
    if session[params[:id]].nil? || !Repository.exists?(token: params[:id])

      # Always redirect to login even if repo does not exists, in order to prevent information leakage
      redirect_to(controller: :repositories, action: :authenticate, id: params[:id])

    else
      # User may access repository, verify if user can access record
      unless params[:record_id].nil?
        repo = Repository.find_by(token: params[:id])

        # No link between Repository and Record, so not allowed access
        unless Record.exists?(repositories_id: repo.id, token: params[:record_id])
          flash[:alert] = 'Something went wrong'
          redirect_to(controller: :repositories, action: :show, id: repo.token)
        end
      end
    end
  end

  def verify_tokens
    tokens = [:id, :record_id]
    tokens.each do |token|
      if params[token] && /\A[\da-f]{32}\z/ !~ params[token]
        flash[:alert] = translate(:invalid_token)
        redirect_to(controller: :main, action: :index)
      end
    end
  end

  def session_key=(repository)
    session[repository.token] = b64_encode repository.master_key
  end

  def session_key(repository)
    b64_decode session[repository.token]
  end
end
