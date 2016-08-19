class RecordNotifier < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.record_notifier.created.subject
  #
  def created(repo, request)
    @repo = repo
    @url = url_for(controller: :repositories, action: :show, id: @repo.token, host: request.host_with_port)

    mail to: @repo.email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.record_notifier.deleted.subject
  #
  def deleted(repo, request)
    @repo = repo
    @url = url_for(controller: :repositories, action: :show, id: @repo.token, host: request.host_with_port)

    mail to: @repo.email
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.record_notifier.accessed.subject
  #
  def accessed(repo, request)
    @repo = repo
    @url = url_for(controller: :repositories, action: :show, id: @repo.token, host: request.host_with_port)

    mail to: @repo.email
  end
end
