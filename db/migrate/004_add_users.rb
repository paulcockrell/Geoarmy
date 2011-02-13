class AddUsers < ActiveRecord::Migration
  def self.up
    User.create(:name=>'admin',
                :hashed_password=>'1d84c198ce2ee9a33d899c52f00cdf65c430276f',
                :salt=>'-6213661980.416092667329015'
               )
  end

  def self.down
      User.delete_all
  end
end
