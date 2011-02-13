class AddGoodEvilUser < ActiveRecord::Migration
    def self.up
        add_column :users, :goodpirate, :bool, :default=>false
    end

    def self.down
        remove_column :users, :goodpirate
    end
end

