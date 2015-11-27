class MainController < ApplicationController

  def index
    auth = false
    if auth
      redirect_to({ :action=>'create_repo' }, :alert => 'Something serious happened')
    end
  end

  def create_repo

  end
end
