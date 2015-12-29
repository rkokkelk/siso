class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def ip_authentication
    if not IpHelper.verifyIP request.ip
      redirect_to(controller: :main, action: :index)
    end
  end

  def authentication

    if session[params[:id]].nil?
      redirect_to(controller: :repositories, :action => :authenticate, :id => params[:id])
    else
      if not params[:record_id].nil?
        repo = Repository.find_by(token: params[:id])
        if not Record.exists?(repositories_id: repo.id, token: params[:record_id])
          flash[:alert] = 'Something went wrong'
          redirect_to(controller: :repositories, action: :show, :id => params[:id])
        end
      end
    end
  end
end
