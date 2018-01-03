# frozen_string_literal: true

module AddwordCommand
  extend ActiveSupport::Concern

  included do
    context_handler :addword do |*words|
      word = session.delete(:word)
      session.delete(:translation)
      current_user.current_words.create!(word: word, translation: words.first, pos: :noun, gen: :m)
      respond_with :message, text: t('telegram_webhooks.addword.word_added', word: word, translation: words.first)
    end
  end

  # rubocop:disable Metrics/AbcSize
  def addword(*args)
    return respond_with :message, text: t('.usage') if args.empty?
    return respond_with :message, text: t('.usage') if args.count > 2
    return respond_with :message, text: t('.select_language') if current_user.language.nil?
    return respond_with :message, text: t('.already_added', word: args.first) if current_user.word?(args.first).present?
    if args.count == 1
      translation = TRANSLATOR.translate args.first, from: current_user.language.code, to: 'ru'
      save_context :word_confirmation
      session[:translation] = translation
      session[:word] = args.first
      return respond_with :message, text: t('.is_it_right_translation', translation: translation),
                                    reply_markup: { inline_keyboard: yes_no_inline_keyboard }
    end
    current_user.current_words.create!(word: args.first, translation: args.second, pos: :noun, gen: :m)
    respond_with :message, text: t('.word_added', word: args.first, translation: args.second)
  end
  # rubocop:enable Metrics/AbcSize

  protected

  # rubocop:disable Metrics/AbcSize
  def handle_callback_query_action_word_confirmation(query)
    case query
    when 'yes'
      current_user.current_words.create!(
        session.to_h.symbolize_keys.slice(:word, :translation).merge(pos: :noun, gen: :m)
      )
      edit_message :text, text: t('telegram_webhooks.addword.word_added',
                                  session.to_h.symbolize_keys.slice(:word, :translation))
    when 'no'
      save_context :addword
      edit_message :text, text: t('telegram_webhooks.addword.send_valid')
    when 'cancel'
      session.delete(:word)
      session.delete(:translation)
      edit_message :text, text: t('common.canceled')
    end
  end
  # rubocop:enable Metrics/AbcSize
end
