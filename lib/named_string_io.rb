# frozen_string_literal: true

class NamedStringIO < StringIO
  attr_accessor :filepath

  def initialize(content, filepath)
    super(content)
    @filepath = filepath
  end

  def original_filename
    File.basename(@filepath)
  end
end
