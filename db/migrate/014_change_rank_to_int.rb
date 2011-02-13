class ChangeRankToInt < ActiveRecord::Migration
    def self.up
        change_column :users, :rank, :integer, :default => 0
    end
    def self.down
        change_column :users, :rank, :string
    end
end
