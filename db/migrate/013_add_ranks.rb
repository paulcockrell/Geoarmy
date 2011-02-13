class AddRanks < ActiveRecord::Migration
  def self.up
      Rank.create(:from =>'0',
                  :to   =>'100',
                  :rank =>'Junior Geocacher',
                  :image=>'junior.png'
                 )
      Rank.create(:from =>'101',
                  :to   =>'200',
                  :rank =>'Intermediate Geocacher',
                  :image=>'intermediate.png'
                 )
      Rank.create(:from =>'201',
                  :to   =>'300',
                  :rank =>'Advanced Geocacher',
                  :image=>'advanced.png'
                 )
      Rank.create(:from =>'301',
                  :to   =>'400',
                  :rank =>'Super Geocacher',
                  :image=>'super.png'
                 )
      Rank.create(:from =>'401',
                  :to   =>'9999999',
                  :rank =>'Ultimate Geocacher',
                  :image=>'ultimate.png'
                 )
      
  end

  def self.down
      Rank.delete_all
  end
end
