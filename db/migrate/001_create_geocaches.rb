class CreateGeocaches < ActiveRecord::Migration
  def self.up
    create_table :geocaches do |t|
      t.integer :users_id
      t.string :geocode
      t.text :notes

      t.timestamps
    end
  end

  def self.down
    drop_table :geocaches
  end
end
