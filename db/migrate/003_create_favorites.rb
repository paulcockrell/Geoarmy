class CreateFavorites < ActiveRecord::Migration
  def self.up
    create_table :favorites do |t|
      t.integer :user_id, :size=>11, :null=>false
      t.integer :geocache_id, :size=>11, :null=>false;
      t.timestamps
    end
  end

  def self.down
    drop_table :favorites
  end
end
