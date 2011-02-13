class AddUserResetKey < ActiveRecord::Migration
    def self.up
        add_column :users, :key, :string, :default => nil
    end

    def self.down
        remove_column :users, :key
    end
end

