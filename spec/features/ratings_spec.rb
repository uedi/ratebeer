require 'rails_helper'

include Helpers

describe "Ratings" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }
  let!(:user2) { FactoryGirl.create :user, username:"Pekka2" }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end
  
  #it "are listed at ratings page" do
  #  create_ratings
  #  visit ratings_path
  #  expect(page).to have_content 'Number of ratings: 3'
  #  expect(page).to have_content 'iso 3 10 Pekka'
  #  expect(page).to have_content 'Karhu 20 Pekka'
  #  expect(page).to have_content 'Karhu 21 Pekka2'
  #end
  
  it "made by user are listed at their page" do
    create_ratings
    visit user_path(user)
    expect(page).to have_content 'has made 2 ratings'
    expect(page).to have_content 'iso 3 10'
    expect(page).to have_content 'Karhu 20'
    expect(page).not_to have_content 'Karhu 21'
  end
  
  it "can be deleted by user" do
    create_ratings
    visit user_path(user)
    expect(page).to have_content 'iso 3 10'
    expect{
      page.find('li', :text => 'iso 3').click_link('delete')
    }.to change{user.ratings.count}.from(2).to(1)
    expect(page).not_to have_content 'iso 3 10'
  end
  
  
  def create_ratings
    FactoryGirl.create :rating, beer_id:1, user_id:1
    FactoryGirl.create :rating2, beer_id:2, user_id:1
    FactoryGirl.create :rating2, score:21, beer_id:2, user_id:2
  end
  
end

