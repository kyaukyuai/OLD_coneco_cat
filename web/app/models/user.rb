class User < ActiveRecord::Base
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]
#          :confirmable, :omniauthable

  include DeviseTokenAuth::Concerns::User
#  # Include default devise modules. Others available are:
#  # :confirmable, :lockable, :timeoutable and :omniauthable
#  devise :database_authenticatable, :omniauthable, :registerable,
#         :recoverable, :rememberable, :trackable, :validatable

#  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
#    user = User.where(:provider => auth.provider, :uid => auth.uid).first
#    unless user
#      user = User.create(
#        provider:         auth.provider,
#        uid:              auth.uid,
#        email:            auth.info.email,
#        image:            auth.info.image,
#        oauth_token:      auth.credentials.token,
#        oauth_expires_at: '',
#        password:         Devise.friendly_token[0,20]
#      )
#    end
#    user
#  end
#
#  def self.new_with_session(params, session)
#    super.tap do |user|
#      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
#          user.email = data["email"] if user.email.blank?
#      end
#    end
#  end
#
#  def self.create_unique_string
#    SecureRandom.uuid
#  end

end
