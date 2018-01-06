# frozen_string_literal: true

require 'open3'

class TTS::OggConverter
  def convert(data)
    Open3.popen3('ffmpeg -i - -f opus -') do |i, o, _, _|
      i.binmode
      i.write data
      i.close
      return o.read
    end
  end
end
