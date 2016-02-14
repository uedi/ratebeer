require 'rails_helper'

include Helpers

RSpec.describe User, type: :model do

  it "has the username set correctly" do
    user = User.new username:"Pekka"
    expect(user.username).to eq("Pekka")
  end
  
  it "is not saved without a password" do
    user = User.create username:"Pekka"
    # expect(user.valid?).to be(false)
    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end
  
  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }
    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)
      expect(user.ratings.count).to eq(2)
      expect(user.average_rating).to eq(15.0)
    end
  end
  
  describe "is not saved if password" do
    def test_password pw
      user = User.create username:"Pekka", password: pw, password_confirmation: pw
      expect(user).not_to be_valid
      expect(User.count).to eq(0)
    end
    it "is too short" do
      test_password "Pw1"
    end
    it "is without number" do
      test_password "Pwwww"
    end
    it "is without upper-case letter" do
      test_password "ppppwww1"
    end
  end

  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }
    
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_beer)
    end

    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end
    
    it "is the only rated if only one rating" do
      # beer = FactoryGirl.create(:beer)
      # rating = FactoryGirl.create(:rating, beer:beer, user:user)
      beer = create_beer_with_rating(user, 10)
      expect(user.favorite_beer).to eq(beer)
    end
    
    it "is the one with highest rating if several rated" do
      create_beers_with_ratings(user, 10, 20, 15, 7, 9)
      best = create_beer_with_rating(user, 25)
      expect(user.favorite_beer).to eq(best)
    end
  end # end of "favorite beer"
  
  describe "favorite style" do
    let(:user){FactoryGirl.create(:user) }
    
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_style)
    end
    
    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end
    
    it "is the only style if only one rating" do
      beer = create_beer_with_rating_and_style(user, 10, "Weizen")
      expect(user.favorite_style).to eq(beer.style)
    end
    
    it "is the one with best average score" do
      create_beer_with_rating_and_style(user, 10, "Weizen")
      create_beer_with_rating_and_style(user, 30, "Weizen")
      create_beer_with_rating_and_style(user, 20, "Weizen")
      best = create_beer_with_rating_and_style(user, 21, "IPA")
      expect(user.favorite_style).to eq(best.style)
    end
  end # end of "favorite style"
  
  describe "favorite brewery" do
    let(:user){FactoryGirl.create(:user) }
    
    it "has method for determining one" do
      expect(user).to respond_to(:favorite_brewery)
    end
    
    it "without ratings does not have one" do
      expect(user.favorite_brewery).to eq(nil)
    end
    
    it "is the only one with a beer rated" do
      brewery = FactoryGirl.create(:brewery, name:"Panimo")
      add_rated_beer_to_brewery(brewery, user, 10)
      expect(user.favorite_brewery.name).to eq(brewery.name)
    end
    
    it "is the one with best average score" do
      brewery = FactoryGirl.create(:brewery, name:"Panimo")
      brewery2 = FactoryGirl.create(:brewery, name:"Panimo2")
      add_rated_beer_to_brewery(brewery, user, 20)
      add_rated_beer_to_brewery(brewery, user, 30)
      add_rated_beer_to_brewery(brewery2, user, 26)
      expect(user.favorite_brewery.name).to eq(brewery2.name)
    end
    
  end # end of "favorite brewery"
    
  def create_beers_with_ratings(user, *scores)
    scores.each do |score|
      create_beer_with_rating user, score
    end
  end
  
end

