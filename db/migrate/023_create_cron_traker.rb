class CreateCronTraker < ActiveRecord::Migration
  def self.up
    create_table :cron_traker do |t|
      t.integer :cron_id
      t.integer :increment_value_traker
    end
  end

  def self.down
    drop_table :ranks
  end
end
