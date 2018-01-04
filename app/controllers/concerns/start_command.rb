# frozen_string_literal: true

module StartCommand
  def start(*)
    return start_with_existing_user if current_user.present?

    User.create!(user_id: from.id, username: from.username)
    respond_with :message, text: t('.hi', name: user_greeting(from))
  end

  protected

  def start_with_existing_user
    return respond_with :message, text: t('.already_started') if current_user.active?

    current_user.update_attributes(active: true)
    respond_with :message, text: t('.reactivated')
  end
end
