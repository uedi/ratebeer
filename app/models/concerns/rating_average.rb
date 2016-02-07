module RatingAverage
  extend ActiveSupport::Concern
  
  def average_rating
    ratings.average(:score).round(1)
  end
end
