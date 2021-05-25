class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include Visible
  has_many :articles, dependent: :destroy
  before_save :encrypt_password
  after_save :clear_password

  attr_accessor :password
  validates :username, :presence => true, :uniqueness => true, :length => { :in => 5..20 }
  validates :email, :presence => true, :uniqueness => true
  validates :password, :confirmation => true
  validates_length_of :password, :in => 8..25, :on => :create

  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.enc_password= BCrypt::Engine.hash_secret(password, salt)
    end
  end
  def clear_password
    self.password = nil
  end
end