# frozen_string_literal: true

module UsersHelper
  def user_greeting(u)
    return "#{u.first_name} #{u.last_name}" if u.first_name.present? && u.last_name.present?
    return u.username if u.username.present?
    t('common.my_friend')
  end

  def current_user
    @current_user ||= User.find_by(user_id: from.id)
  end

  def current_language
    @current_language ||= current_user.language.code
  end

  def language_supported?(lang)
    ['ru', current_language].include?(lang)
  end
end
