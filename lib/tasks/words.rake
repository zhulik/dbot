# frozen_string_literal: true

namespace :words do
  # rake 'words:copy[1,2]'
  desc 'Copy words to other user'
  task :copy, %i[from to] => :environment do |_t, args|
    Word.where(user_id: args[:from]).find_each do |w|
      Word.create!(w.attributes.merge('user_id': args[:to]).except('id'))
    rescue StandardError
      puts "#{w.word} already exists for user #{args[:to]}"
      nil
    end
  end
end
