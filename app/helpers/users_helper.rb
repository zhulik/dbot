# frozen_string_literal: true

module UsersHelper
  def user_greeting(u)
    return "#{u.first_name} #{u.last_name}" if u.first_name.present? && u.last_name.present?
    return u.username if u.username.present?
    t('defaults.my_friend')
  end

  def current_user
    User.find_by(user_id: payload.from.id)
  end
end
