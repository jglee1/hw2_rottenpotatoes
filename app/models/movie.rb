class Movie < ActiveRecord::Base
  def self.rating_list
    return ['G', 'PG', 'PG-13', 'R']
  end
end
