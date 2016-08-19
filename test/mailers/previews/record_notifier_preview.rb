# Preview all emails at http://localhost:3000/rails/mailers/record_notifier
class RecordNotifierPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/record_notifier/created
  def created
    RecordNotifier.created
  end

  # Preview this email at http://localhost:3000/rails/mailers/record_notifier/deleted
  def deleted
    RecordNotifier.deleted
  end

  # Preview this email at http://localhost:3000/rails/mailers/record_notifier/accessed
  def accessed
    RecordNotifier.accessed
  end

end
