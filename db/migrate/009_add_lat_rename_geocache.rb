class AddLatRenameGeocache < ActiveRecord::Migration
    def self.up
        add_column :geocaches, :lon, :string, :null=>false
        rename_column :geocaches, :geocode, :lat
    end
    def self.down
        remove_column :geocaches, :lon
        rename_column :geocaches, :lat, :geocode
    end
end
