# frozen_string_literal: true

class StartCommand < Command
  usage -> { I18n.t('dbot.start.usage') }
  help -> { I18n.t('dbot.start.help') }
  arguments 0

  def message(*args)
    return respond_message text: self.class.usage if args.any?
    return start_with_existing_user if current_user.present?
    User.create!(user_id: from.id, username: from.username)
    respond_message text: t('dbot.start.hi', name: user_greeting(from))
  end

  private

  def start_with_existing_user
    return respond_message text: t('dbot.start.already_started') if current_user.active?

    current_user.update_attributes(active: true)
    respond_message text: t('dbot.start.reactivated')
  end
end
