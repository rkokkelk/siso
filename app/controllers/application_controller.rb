class ApplicationController < ActionController::Base
  include I18n

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Standard input validation actions
  before_action :verify_tokens

  def session_key=(repository)
    session[repository.token] = b64_encode repository.master_key
  end

  def session_key(repository)
    b64_decode session[repository.token]
  end

  def ip_authentication
    unless IpHelper.verifyIP request.remote_ip
      redirect_to(controller: :main, action: :index)
    end
  end

  def authentication
    repo = Repository.find_by(token: params[:id])

    # Verify if the use can access the requested repository
    if repo.nil? || session[repo.token].nil?
      # Always redirect to login even if repo does not exists, in order to prevent information leakage
      redirect_to(controller: :repositories, action: :authenticate, id: params[:id])
      return
    end

    if params[:record_id] && !Record.exists?(repositories_id: repo.id, token: params[:record_id])
      # No link between Repository and Record, so not allowed access
      redirect_to(controller: :repositories, action: :show, id: repo.token)
    end
  end

  private

  def verify_tokens
    tokens = [:id, :record_id]
    tokens.each do |token|
      if params[token] && /\A[\da-f]{32}\z/ !~ params[token]
        flash[:alert] = translate(:invalid_token)
        redirect_to(controller: :main, action: :index)
        return
      end
    end
  end
end
