require 'rails_helper'

describe "Places" do
  it "if one is returned by the API, it is shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("kumpula").and_return(
      [ Place.new( name:"Oljenkorsi", id: 1 ) ]
    )

    visit places_path
    fill_in('city', with: 'kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
  end
  
  it "if two are returned by the API, they are shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("Kumpula").and_return(
      [ Place.new( name:"Oljenkorsi", id: 1 ), Place.new( name:"Pub", id: 2 ) ]
    )

    visit places_path
    fill_in('city', with: 'Kumpula')
    click_button "Search"

    expect(page).to have_content "Oljenkorsi"
    expect(page).to have_content "Pub"
  end
  
  it "if nothing returned by the API, no locations shown at the page" do
    allow(BeermappingApi).to receive(:places_in).with("Mars").and_return([])

    visit places_path
    fill_in('city', with: 'Mars')
    click_button "Search"
    
    expect(page).to have_content "No locations in Mars"
  end
  
end
