# frozen_string_literal: true

class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include ControllerConfig

  def start
    return start_with_existing_user if current_user.present?

    User.create!(user_id: from.id)
    respond_with :message, text: t('.hi', name: user_greeting(from))
  end

  def languages
    return respond_with :message, text: t('.no_languages') if Language.all.empty?
    save_context :languages
    respond_with :message, text: t('.choose_language'), reply_markup: { inline_keyboard: languages_inline_keyboard }
  end

  # rubocop:disable Metrics/AbcSize
  def addword(*args)
    return respond_with :message, text: t('.usage') if args.empty?
    return respond_with :message, text: t('.usage') if args.count > 2
    return respond_with :message, text: t('.select_language') if current_user.language.nil?
    return respond_with :message, text: t('.already_added', word: args.first) if current_user.word?(args.first).present?
    if args.count == 1
      translation = TRANSLATOR.translate args.first, from: current_user.language.slug, to: 'ru'
      save_context :word_confirmation
      session[:translation] = translation
      session[:word] = args.first
      return respond_with :message, text: t('.is_it_right_translation', translation: translation),
                                    reply_markup: { inline_keyboard: yes_no_inline_keyboard }
    end
    current_user.current_words.create!(word: args.first, translation: args.second)
    respond_with :message, text: t('.word_added', word: args.first, translation: args.second)
  end
  # rubocop:enable Metrics/AbcSize

  def callback_query(query)
    context = session.delete(:context)
    return answer_callback_query t('.unknown_action') if context.nil?
    send("handle_callback_query_action_#{context}", query)
  end

  context_handler :addword do |*words|
    word = session.delete(:word)
    session.delete(:translation)
    current_user.current_words.create!(word: word, translation: words.first)
    respond_with :message, text: t('telegram_webhooks.addword.word_added', word: word, translation: words.first)
  end

  private

  def handle_callback_query_action_languages(query)
    language = Language.find_by(slug: query)
    return edit_message :text, text: t('.unknown_language', slug: query) if language.nil?
    current_user.update_attributes!(language: language)
    edit_message :text, text: t('.language_accepted', name: language.name)
  end

  def handle_callback_query_action_word_confirmation(query)
    if query == 'yes'
      current_user.current_words.create!(session.slice(:word, :translation))
      edit_message :text, text: t('telegram_webhooks.addword.word_added', session.slice(:word, :translation))
    else
      save_context :addword
      edit_message :text, text: t('telegram_webhooks.addword.send_valid')
    end
  end

  def start_with_existing_user
    return respond_with :message, text: t('.already_started') if current_user.active?

    current_user.update_attributes(active: true)
    respond_with :message, text: t('.reactivated')
  end
end
