class MainController < ApplicationController
  #include IpHelper

  def index

    if IpHelper.verifyIP request.ip
      redirect_to({ :controller => 'repositories', :action=>'new' })
    else
      render :index
    end
  end
end
