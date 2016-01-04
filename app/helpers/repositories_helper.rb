module RepositoriesHelper

  def clear_old_repositories
    repositories = Repository.all
    repositories.each do |repository|
      if repository.deleted_at.past?
        if repository.destroy
          Rails.logger.info{"Deleted repository: #{repository.token}"}
        else
          Rails.logger.error{"Error removing repository: #{repository.errors}"}
        end
      end
    end
  end
end
