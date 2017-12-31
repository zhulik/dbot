# frozen_string_literal: true

class TelegramWebhooksController < Telegram::Bot::UpdatesController
  include Telegram::Bot::UpdatesController::TypedUpdate
  include Telegram::Bot::UpdatesController::MessageContext
  include UsersHelper
  include KeyboardsHelper
  self.session_store = :redis_store, { expires_in: 1.month }

  around_action :rescue_not_authorized, except: :start

  before_action :authenticate!, except: :start

  def start
    return start_with_existing_user if current_user.present?

    User.create!(user_id: from.id)
    respond_with :message, text: t('.hi', name: user_greeting(from))
  end

  def languages
    return respond_with :message, text: t('.no_languages') if Language.all.empty?
    respond_with :message, text: t('.choose_language'), reply_markup: languages_inline_keyboard
  end

  # rubocop:disable Metrics/AbcSize
  def addword(*args)
    return respond_with :message, text: t('.usage') if args.empty?
    return respond_with :message, text: t('.usage') if args.count > 2
    return respond_with :message, text: t('.select_language') if current_user.language.nil?
    # TODO: handle existing words
    if args.count == 1
      translation = TRANSLATOR.translate args.first, from: current_user.language.slug, to: 'ru'
      session[:translation] = translation
      respond_with :message, text: t('.is_it_right_translation', translation: translation),
                             reply_markup: yes_no_inline_keyboard(args.first)
    else
      current_user.language.words.where(user: current_user).create!(word: args.first, translation: args.second)
      respond_with :message, text: t('.word_added', word: args.first)
    end
  end
  # rubocop:enable Metrics/AbcSize

  def callback_query(query)
    query = JSON.parse(query, symbolize_names: true)
    return answer_callback_query t('.unknown_action') if query[:a].nil?
    send("handle_callback_query_action_#{query[:a]}", query)
  end

  context_handler :addword do |*words|
    word = session.delete(:word)
    current_user.language.words.where(user: current_user).create!(word: word, translation: words.first)
    respond_with :message, text: t('telegram_webhooks.addword.word_added', word: word)
  end

  private

  def handle_callback_query_action_language(query)
    language = Language.find_by(slug: query[:s])
    return answer_callback_query t('.unknown_language', slug: query[:s]) if language.nil?
    current_user.update_attributes!(language: language)
    answer_callback_query t('.language_accepted', name: language.name)
  end

  def handle_callback_query_action_word_confirmation(query)
    translation = session.delete(:translation)
    if query[:c] == 'yes'
      current_user.language.words.where(user: current_user).create!(word: query[:w], translation: translation)
      edit_message :text, text: t('telegram_webhooks.addword.word_added', word: query[:w])
    else
      save_context :addword
      session[:word] = query[:w]
      edit_message :text, text: t('telegram_webhooks.addword.send_valid')
    end
  end

  def authenticate!
    raise NotStartedError if current_user.nil?
  end

  def start_with_existing_user
    return respond_with :message, text: t('.already_started') if current_user.active?

    current_user.update_attributes(active: true)
    respond_with :message, text: t('.reactivated')
  end

  def rescue_not_authorized
    yield
  rescue NotStartedError
    return answer_callback_query t('common.not_authorized') if payload.is_a? Telegram::Bot::Types::CallbackQuery
    return respond_with :message, text: t('common.not_authorized')
  end
end
