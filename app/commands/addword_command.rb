# frozen_string_literal: true

class AddwordCommand < Command
  usage -> { I18n.t('dbot.addword.usage') }
  help -> { I18n.t('dbot.addword.help') }
  arguments 0, 1, 3, 4

  def message_0
    save_context :addword_send_word
    respond_message text: t('common.send_word')
  end

  def message_1(word)
    short(word)
  end
  alias send_word message_1

  def message_3(word, translation, pos)
    word = { word: word, translation: translation, pos: pos }
    create_word(word)
  end

  def message_4(word, translation, pos, gen)
    word = { word: word, translation: translation, pos: pos, gen: gen }
    create_word(word)
  end

  def callback_query(query)
    return respond_message text: t('common.canceled') if query == 'cancel'
    variants = prepare_workflow(query)
    respond_message text: t('dbot.addword.choose_right_variant'),
                    reply_markup: { inline_keyboard: variants_keyboard(variants, :addword_choose) }
  end

  def choose_callback_query(query)
    if query == 'custom_variant'
      save_context :addword_custom_variant
      return respond_message text: t('dbot.addword.send_translation')
    end
    variants = session[:addword_variants]
    session.clear
    return respond_message text: t('common.canceled') if query == 'cancel'
    word = variants[query.to_i]
    return respond_message, text: t('common.already_added', word: word[:word]) if current_user.word?(word[:word])
    w = current_user.current_words.create!(word)
    respond_message text: t('dbot.addword.word_added', word: w.word, translation: w.translation)
  end

  def custom_variant(*args)
    save_context :addword_custom_variant
    return respond_message text: self.class.usage if args.count < 2 || args.count > 3
    word = { word: session[:addword_word], translation: args.first, pos: args.second, gen: args.third }
    word[:word], word[:translation] = word[:translation], word[:word] if session.delete(:addword_inverse)
    create_word(word)
  end

  private

  def create_word(w)
    session.clear
    Words::Create.call([current_user, w]) do |res|
      res.on_success do
        return respond_message text: t('dbot.addword.word_added', w)
      end
      res.on_fail do |error|
        send(error.type, error.data)
      end
    end
  end

  def short(word)
    variants = prepare_workflow(word)
    respond_message text: t('dbot.addword.choose_right_variant'),
                    reply_markup: { inline_keyboard: variants_keyboard(variants, :addword_choose) }
  end

  def unknown_gen(w)
    respond_message text: t('common.unknown_gen', gen: w[:gen], valid: Word.gens.keys.join(', '))
  end

  def unknown_pos(w)
    respond_message text: t('common.unknown_pos', pos: w[:pos], valid: Word.pos.keys.join(', '))
  end

  def already_added(w)
    respond_message text: t('common.already_added', word: w[:word])
  end

  def prepare_workflow(word)
    inverse = Translators::YandexWrapper.new(word).detect == 'ru'
    if inverse # If source language is russian use native addword workflow, otherwise user target lang
      Dictionaries::YandexWrapper.new(word, from: 'ru', to: current_language,
                                            inverse: inverse).variants
    else
      Dictionaries::YandexWrapper.new(word, from: current_language, to: 'ru').variants
    end.tap do |variants|
      session[:addword_variants] = variants
      session[:addword_word] = word
      session[:addword_inverse] = inverse
    end
  end

  def variants_keyboard(variants, ctx)
    InlineKeyboard.render do |k|
      variants.map.with_index do |var, index|
        k.row do |r|
          r.button "#{var[:word]} - #{var[:translation]} #{var[:pos]} #{var[:gen]}", ctx, index
        end
      end
      k.row do |r|
        r.button InlineKeyboard::Buttons.cancel(ctx)
        r.button t('common.custom_variant'), ctx, :custom_variant
      end
    end
  end
end
