require 'rails_helper'

RSpec.describe Beer, type: :model do
  it "with name and style is saved" do
    style = Style.create(name:"Lager", description:"Lager...")
    beer = Beer.create name:"Yokohama Weizen", style_id:1
    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end
  it "without name is not saved" do
    style = Style.create(name:"Lager", description:"Lager...")
    beer = Beer.create name:"", style_id:1
    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
  it "without style is not saved" do
    beer = Beer.create name:"Water"
    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
  
end
