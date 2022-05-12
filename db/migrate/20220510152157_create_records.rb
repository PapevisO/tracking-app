class CreateRecords < ActiveRecord::Migration[6.0]
  def change
    create_table :records do |t|
      t.datetime :visited_at
      t.string :ip
      t.string :location
      t.string :os
      t.string :device
      t.string :referrer
      t.string :url
      t.string :language
      
      t.timestamps
    end
  end
end
