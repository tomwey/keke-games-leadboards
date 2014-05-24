class Game < ActiveRecord::Base
  attr_accessible :game_key, :name
  
  has_many :leaderboards
  
  after_initialize :generate_game_key
  def generate_game_key
    if new_record?
      self.game_key = SecureRandom.uuid.gsub(/-/, '')
    end
  end
  
end
