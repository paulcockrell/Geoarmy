class RenameUsersidColumn < ActiveRecord::Migration
    def self.up
        rename_column :geocaches, :users_id, :user_id
    end

    def self.down
        rename_column :geocaches, :user_id, :users_id
    end
end
