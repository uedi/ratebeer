require 'rails_helper'

include Helpers

describe "User" do
  #before :each do
  #  FactoryGirl.create :user
  #end
  let!(:user) { FactoryGirl.create :user }

  describe "who has signed up" do
  
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")
      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end
    
    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")
      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'Username and/or password mismatch'
    end
    
    it "when signed up with good credentials, is added to the system" do
      visit signup_path
      fill_in('user_username', with:'Brian')
      fill_in('user_password', with:'Secret55')
      fill_in('user_password_confirmation', with:'Secret55')
      expect{
        click_button('Create User')
      }.to change{User.count}.by(1)
    end
    
    it "doesn't have favorite style or brewery if no rated beers" do
      visit user_path(user)
      expect(page).not_to have_content 'favorite'
    end
    
    it "has favorite style" do
      weizen = Style.create(name:"Weizen", description:"ddd...")
      ipa = Style.create(name:"IPA", description:"ddd...")
      create_beer_with_rating_and_style(user, 20, weizen)
      create_beer_with_rating_and_style(user, 24, weizen)
      create_beer_with_rating_and_style(user, 21, ipa)
      create_beer_with_rating_and_style(user, 22, ipa)
      create_beer_with_rating_and_style(user, 22, ipa)
      visit user_path(user)
      expect(page).to have_content 'favorite style: Weizen'
    end
    
    it "has favorite brewery" do
      brewery = FactoryGirl.create(:brewery, name:"Panimo")
      brewery2 = FactoryGirl.create(:brewery, name:"Panimo2")
      add_rated_beer_to_brewery(brewery, user, 10)
      add_rated_beer_to_brewery(brewery, user, 20)
      add_rated_beer_to_brewery(brewery2, user, 16)
      add_rated_beer_to_brewery(brewery, user, 15)
      visit user_path(user)
      expect(page).to have_content 'favorite brewery: Panimo2'
    end
    
  end
end

