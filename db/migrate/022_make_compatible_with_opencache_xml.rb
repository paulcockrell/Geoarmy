class MakeCompatibleWithOpencacheXml < ActiveRecord::Migration
    def self.up
        add_column :geocaches, :opencache_id, :int
        add_column :geocaches, :owner, :string
        add_column :geocaches, :status, :string
        add_column :geocaches, :geo_type, :string
        add_column :geocaches, :difficulty, :string
        add_column :geocaches, :terrain, :string
        add_column :geocaches, :size, :string
    end

    def self.down
        remove_column :geocaches, :opencache_id
        remove_column :geocaches, :owner
        remove_column :geocaches, :status
        remove_column :geocaches, :geo_type
        remove_column :geocaches, :difficulty
        remove_column :geocaches, :terrain
        remove_column :geocaches, :size
    end
end

