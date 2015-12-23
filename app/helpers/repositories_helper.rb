module RepositoriesHelper

  def clear_old_repositories
    repositories = Repository.all
    repositories.each do |repository|
      if repository.deletion.past?
        if repository.destroy
          Rails.logger.info{"Deleted repository: #{repository.id}"}
        else
          Rails.logger.error{"Error removing repository: #{repository.errors}"}
        end
      end
    end
  end
end
