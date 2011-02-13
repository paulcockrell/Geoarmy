class AddUserProfileFields < ActiveRecord::Migration
    def self.up
        add_column :users, :rank, :string
        add_column :users, :address_1, :string
        add_column :users, :address_2, :string
        add_column :users, :address_3, :string
        add_column :users, :postcode, :string
        add_column :users, :email, :string
    end

    def self.down
        remove_column :users, :rank
        remove_column :users, :address_1
        remove_column :users, :address_2
        remove_column :users, :address_3
        remove_column :users, :postcode
        remove_column :users, :email
    end
end

