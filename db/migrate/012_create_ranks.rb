class CreateRanks < ActiveRecord::Migration
  def self.up
    create_table :ranks do |t|
      t.integer :from
      t.integer :to
      t.string  :rank
      t.string  :image
    end
  end

  def self.down
    drop_table :ranks
  end
end
