class Geocache < ActiveRecord::Base
	belongs_to :users
    has_many :favorites
    has_many :views
    has_many :ratings
    has_many :found
    validates_presence_of :name, :lat, :lon
	validates_length_of   :lat, :lon, :within => 5..10, :too_long => 'Geocode can be a maximum of 10 digits long', :too_short => 'Geocode can be a minimum of 5 digits long'
    validates_format_of   :lat, :lon, :with => /\A\-?\d{1,3}\.\d+\z/
    validates_format_of   :name, :notes, :with => /\A[\w\s]+\z/
    after_save :log

    def log
        logme(self.user_id,self.id,'created a new geocache')
    end

    def get_geocache_group_count(id = null, pirate_type = 0)
        sql = "geocaches.id, geocaches.name, count(*) as count from found left join users on found.user_id = users.id left join geocaches on found.geocache_id = geocaches.id"
        sql_conditions  = " where users.goodpirate = #{pirate_type}"
        sql_conditions  = " and geocaches.id = #{id}"
        sql_conditions += " group by geocaches.name"
        sql_conditions += " order by geocaches.id"
    end
end
