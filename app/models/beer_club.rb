class BeerClub < ActiveRecord::Base

  has_many :memberships, dependent: :destroy
  has_many :members, through: :memberships, source: :user
    
  def to_s
    "#{name} (#{city})"
  end
  
  def is_member(user)
    membership = memberships.find_by(beer_club_id: self.id, user_id: user.id)
    return false if membership.nil?
    membership.confirmed
  end

end
