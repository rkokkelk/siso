class MainController < ApplicationController

  def index
    auth = true
    if auth
      redirect_to({ :controller => 'repositories', :action=>'new' })
    end
  end

end
