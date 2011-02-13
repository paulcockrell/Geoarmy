class AddNameToGeocache < ActiveRecord::Migration
    def self.up
        add_column :geocaches, :name, :string, :null => false
    end

    def self.down
        remove_column :geocaches, :name
    end
end
