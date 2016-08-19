class RecordNotifier < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.record_notifier.created.subject
  #
  def created(repo)
    @repo = repo

    mail to: "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.record_notifier.deleted.subject
  #
  def deleted(repo)
    @repo = repo

    mail to: "to@example.org"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.record_notifier.accessed.subject
  #
  def accessed(repo)
    @repo = repo

    mail to: 'roy.kokkelkoren@gmail.com', subject: 'test'
  end
end
