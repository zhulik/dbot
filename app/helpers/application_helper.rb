# frozen_string_literal: true

module ApplicationHelper
  def respond_message(**params)
    case payload
    when Telegram::Bot::Types::CallbackQuery
      edit_message :text, **params
    when Telegram::Bot::Types::Message
      respond_with :message, **params
    end
  end

  def chat
    payload&.chat || x&.message&.chat
  end

  def from
    payload&.from
  end

  def user_greeting(u)
    return "#{u.first_name} #{u.last_name}" if u.first_name.present? && u.last_name.present?
    return u.username if u.username.present?

    t('common.my_friend')
  end

  def current_user
    User.find_by(user_id: from.id)
  end

  def current_language
    current_user.language&.code
  end

  def with_article(word)
    WordPresenter.new(word.word, word.translation, word.pos, word.gen).with_article
  end

  def full_description(word)
    WordPresenter.new(word.word, word.translation, word.pos, word.gen).full_description
  end
end
