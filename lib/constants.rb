# frozen_string_literal: true

module Constants
  ARTICLES = {
    'f' => 'die',
    'm' => 'der',
    'n' => 'das'
  }.freeze

  PREFIXES = {
    'detachable' => %w(auf ab an aus ein gegen fest fern fort bei vorbei vor kennen spasieren zusammen zu),
    'undetachable' => %w(er be ge ent emp ver zer miß wider),
    'semi-detachable' => %w(wieder über unter durch um)
  }.freeze
end
