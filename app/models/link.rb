# frozen_string_literal: true

class Link
  SHORT_LINK_LETTERS = [('a'..'z'), ('A'..'Z')].map(&:to_a).flatten.freeze
  include ActiveModel::Validations

  attr_accessor :url

  validates :url, presence: true, url: true
  
  def self.get(shorten_link)
    Redis.current.get(shorten_link)
  end
  
  def save
    loop do
      @path_key = generate_key
      unless Redis.current.exists(@path_key)
        Redis.current.set(@path_key, @url)
        break
      end
    end
    self
  end
  
  def persisted?
    Redis.current.exists(@path_key)
  end
  
  def to_key
    return nil unless @path_key
    [@path_key]
  end

  private

  def generate_key
    SHORT_LINK_LETTERS.sample(8).join
  end
end
