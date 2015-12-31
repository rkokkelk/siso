class MainController < ApplicationController
  #include IpHelper

  def index

    if IpHelper.verifyIP request.ip
      redirect_to({ :controller => 'repositories', :action=>'new' })
    else
      render :index
    end
  end

  def page_not_found
    render :not_found, status: 400
  end

  def retry_later
    render :retry_later, :status => 429
  end

  def server_error
    render :server_error, status: 500
  end
end
