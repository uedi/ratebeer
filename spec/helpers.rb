module Helpers

  def sign_in(credentials)
    visit signin_path
    fill_in('username', with:credentials[:username])
    fill_in('password', with:credentials[:password])
    click_button('Log in')
  end
  
  def create_beer_with_rating(user, score)
    style = Style.create(name:"Lager", description:"Lager...")
    create_beer_with_rating_and_style(user, score, style)
  end
  
  def create_beer_with_rating_and_style(user, score, style)
    beer = FactoryGirl.create(:beer, style:style)
    FactoryGirl.create(:rating, score:score, beer:beer, user:user)
    beer
  end
  
  def add_rated_beer_to_brewery(brewery, user, score)
    brewery.beers << create_beer_with_rating(user, score)
  end
  
end
