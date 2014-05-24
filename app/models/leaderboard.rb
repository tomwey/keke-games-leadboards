class Leaderboard < ActiveRecord::Base
  attr_accessible :game_id, :name
  
  PER_PAGE = 10
  
  belongs_to :game
  has_many :scores
  
  def self.page(page)
    offset = ( page - 1 ) * PER_PAGE
    offset(offset).limit(PER_PAGE)
  end
  
  def as_json(options)
    {
      id: self.id,
      name: self.name,
      game_id: self.game_key
    }
  end
  
end
