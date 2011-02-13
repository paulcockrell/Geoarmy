class ChangeLatToNotNull < ActiveRecord::Migration
    def self.up
        change_column :geocaches, :lat, :string, :null=>false
    end
    def self.down
        change_column :geocaches, :lat, :string, :null=>true
    end
end
