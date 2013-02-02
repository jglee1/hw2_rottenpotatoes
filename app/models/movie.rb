class Movie < ActiveRecord::Base
  def self.all_rating_list
    return ['G', 'PG', 'PG-13', 'R']
  end
end
