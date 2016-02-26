module RatingAverage
  extend ActiveSupport::Concern
  
  def average_rating
    return 0 if ratings.nil? or ratings.count == 0
    ratings.average(:score).round(1)
  end
    
end
