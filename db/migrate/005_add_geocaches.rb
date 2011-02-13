class AddGeocaches < ActiveRecord::Migration
  def self.up
      Geocache.create(:geocode=>'11.22.33.44',
                      :users_id=>'1',
                      :notes=>'This is the first geocache'
                     )
  end

  def self.down
      Geocache.delete_all
  end
end
