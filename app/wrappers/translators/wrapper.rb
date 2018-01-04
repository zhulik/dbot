# frozen_string_literal: true

class Translators::Wrapper
  def initialize(text)
    @text = text
  end

  # Subclasses should implement this method and return string with translation
  def translate(_from, _to)
    raise NotImplementedError
  end

  # Subclasses should implement this method and return string with language code
  def detect
    raise NotImplementedError
  end
end
