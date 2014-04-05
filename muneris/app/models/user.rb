class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable

  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => "friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user

  has_many :userbills
  has_many :bills, :through => :userbills, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [:facebook]

  has_attached_file :avatar, :styles => { :profile => "254x254>", :friend => "80x80>", :list => "35x35>" }, :default_url => "usercircle.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/



	def self.find_for_facebook_oauth(auth)
	  where(auth.slice(:provider, :uid)).first_or_create do |user|
	      user.provider = auth.provider
	      user.uid = auth.uid
	      user.email = auth.info.email
	      user.password = Devise.friendly_token[0,20]
	      user.name = auth.info.name   # assuming the user model has a name
        user.address = auth.info.user_location
        if auth.info.image.present?
           image = auth.info.image
           avatar_url = process_uri(image)
           user.update_attribute(:avatar, URI.parse(avatar_url))
        end
	  end
	end	

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  scope :search , ->(search) do
    if search.blank?
      all
    else
      where('familyname LIKE ?', "%#{search}%")
    end
  end

  def users
    find_users ||  @users
  end

  def find_user
    User.find(:all, :conditions => conditions)
  end

  def name_conditions
    ["users.name LIKE ?", "%#{name}%"] unless name.blank?
  end

  def email_conditions
    ["users.email >= ?", "%#{email}%"] unless email.blank?
  end

  def familyname_conditions
    ["users.familyname <= ?", "%#{familyname}%"] unless familyname.blank?
  end

  def tariff_conditions
    ["users.tariff = ?", "%#{tariff}%"] unless tariff.blank?
  end

  def locale_conditions
    ["users.locale = ?", "%#{locale}%"] unless locale.blank?
  end

  def conditions
    [conditions_clauses.join(' AND '), *conditions_options]
  end

  def conditions_clauses
    conditions_parts.map { |condition| condition.first }
  end

  def conditions_options
    conditions_parts.map { |condition| condition[1..-1] }.flatten
  end

  def conditions_parts
    private_methods(false).grep(/_conditions$/).map { |m| send(m) }.compact
  end

  private

  def self.process_uri(uri)
    require 'open-uri'
    require 'open_uri_redirections'
    open(uri, :allow_redirections => :safe) do |r|
      r.base_uri.to_s
    end
  end

end
