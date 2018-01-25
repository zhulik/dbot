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
    @_chat ||= payload&.chat || x&.message&.chat
  end

  def from
    @_from ||= payload&.from
  end

  def user_greeting(u)
    return "#{u.first_name} #{u.last_name}" if u.first_name.present? && u.last_name.present?
    return u.username if u.username.present?
    t('common.my_friend')
  end

  def current_user
    @current_user ||= User.find_by(user_id: from.id)
  end

  def current_language
    @current_language ||= current_user.language&.code
  end

  def addword_keyboard(word, ctx)
    InlineKeyboard.render do |k|
      k.button t('common.add_word', word: word), ctx, word
      k.button InlineKeyboard::Buttons.cancel(ctx)
    end
  end
end
