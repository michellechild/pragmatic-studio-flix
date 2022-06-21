class User < ApplicationRecord
  
  before_save :set_slug
  before_save :username_to_lowercase
  before_save :email_to_lowercase

  has_secure_password
  has_many :reviews, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_movies, through: :favorites, source: :movie

  validates :name, presence: true

  validates :username, presence: true, 
                      format: { with: /\A[A-Z0-9]+\z/i},
                      uniqueness: { case_sensitive: false }

  validates :email, format: { with: /\S+@\S+/  },
                    uniqueness: { case_sensitive: false }

  validates :password, length: { minimum: 10, allow_blank: true }

  scope :by_name, -> { order(:name)}
  scope :non_admins, -> { by_name.where(admin: false)}

  def gravatar_id
    Digest::MD5::hexdigest(email.downcase)
  end

  def to_param 
    slug
  end

  private

  def set_slug
    self.slug = username
  end

  def username_to_lowercase
    self.username = username.downcase
  end

  def email_to_lowercase
    self.email = email.downcase
  end
end
