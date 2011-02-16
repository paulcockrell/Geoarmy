require 'digest/sha1'

class User < ActiveRecord::Base

  validates_presence_of   :name, :username, :address_1, :postcode, :email
  validates_presence_of :password, :password_confirmation, :on => :create
  validates_uniqueness_of :name, :username
  validates_format_of     :name, :with => /\A[a-zA-Z\s]+\z/
  validates_format_of     :address_1, :address_2, :address_3, :postcode, :with => /\A[\w\s]+\z/
  validates_format_of     :username, :with => /[a-z0-9_-]/
  validates_format_of     :password, :with => /[a-zA-Z_-]/, :on => :create
  validates_format_of     :email, :with => /^(.+)@([^\(\);:,<>]+\.[a-zA-Z]{2,3})/
  validates_length_of     :username, :in => 5..20
  validates_length_of     :password, :in => 5..20, :on => :create
  has_many :geocaches
  has_many :favorites
  has_many :found
  has_many :connections

  attr_accessor :password_confirmation
  validates_confirmation_of :password

  def validate
    errors.add_to_base("Missing password") if hashed_password.blank?
  end

  def after_destroy
      if User.count.zero?
          raise "Can't delete the last user"
      end
  end

  def self.authenticate(username, password)
    user = self.find_by_username(username)
    if user
      expected_password = encrypted_password(password, user.salt)
      if user.hashed_password != expected_password
        user = nil
      end
    end
    user
  end 

  def password
    @password
  end 
  
  def password=(pwd)
    @password=pwd
    create_new_salt
    self.hashed_password = User.encrypted_password(self.password, self.salt)
  end

  def self.user_stats(user)
    stats = {:found=>user.found.find(:all).count, :uploads=>user.geocaches.find(:all).count, :favorites=>user.favorites.find(:all).count}
  end

  def self.get_connections_count(user)
    user.connections.find(:all).count
  end
    
  def self.get_last_found_geocache(user)
    user.found.find(:all, :order => 'created_at DESC', :limit => 1)
  end

  def self.generate_reminder_key(user)
    User.encrypted_password("remindme", user.salt)
  end


  private

  def self.encrypted_password(password, salt)
    string_to_hash = password + "bounty" + salt # 'bounty' makes it harder to guess
    Digest::SHA1.hexdigest(string_to_hash)
  end

  def create_new_salt
    self.salt = self.object_id.to_s + rand.to_s
  end

end
