class CreateStyles < ActiveRecord::Migration
  def change
  
    create_table :styles do |t|
      t.string :name
      t.text :description
      t.timestamps null: false
    end
    
    rename_column :beers, :style, :old_style
    add_column :beers, :style_id, :integer
    
    #["Weizen", "Lager", "Pale ale", "IPA", "Porter"]
    
    Style.create name:"Weizen", description:"Weizen beer..."
    Style.create name:"Lager", description:"Lager beer..."
    Style.create name:"Pale Ale", description:"Pale Ale..."
    Style.create name:"IPA", description:"IPA..."
    Style.create name:"Porter", description:"Porter..."
    Style.create name:"lowalcohol", description:"lowalcohol..."
    
    Beer.all.each do |beer|
      if beer.old_style.nil?
        beer.old_style = "Lager"
      end
		  beer.style = Style.find_by(name:beer.old_style)
		 	beer.save
		end
    
    remove_column :beers, :old_style
  end
end
