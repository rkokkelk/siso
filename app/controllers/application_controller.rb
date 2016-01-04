class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def ip_authentication
    unless IpHelper.verifyIP request.ip
      redirect_to(controller: :main, action: :index)
    end
  end

  def authentication

    if session[params[:id]].nil? or not Repository.exists?(token: params[:id])
      # Always redirect to login even if repo does not exists, in order to prevent information leakage
      redirect_to(controller: :repositories, :action => :authenticate, :id => params[:id])
    else
      unless params[:record_id].nil?
        repo = Repository.find_by(token: params[:id])
        unless Record.exists?(repositories_id: repo.id, token: params[:record_id])
          flash[:alert] = 'Something went wrong'
          redirect_to(controller: :repositories, action: :show, :id => params[:id])
        end
      end
    end
  end
end
