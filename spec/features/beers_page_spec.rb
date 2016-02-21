require 'rails_helper'

include Helpers

describe "New beer" do

  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:style) { FactoryGirl.create :style, name:"Lager", description:"xxx" }
  let!(:user) { FactoryGirl.create :user }
  
  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
    visit new_beer_path
  end

  it "can be created when name is proper" do
    fill_in('beer_name', with:'Olut')
    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)
  end
  
  it "cannot be created if name is empty" do
    fill_in('beer_name', with:'')
    expect{
      click_button "Create Beer"
    }.not_to change{Beer.count}
    expect(page).to have_content "Name can't be blank"
  end
  

end

